require "nokogiri"
require 'pry'
require 'pry-nav'

module Embulk
  module Parser
    class ExtractParser < ParserPlugin
      Plugin.register_parser("extract_parser", self)

      def self.transaction(config, &control)
        schema = config.param("schema", :array)
        task = {
          :schema => schema,
        }
        columns = schema.each_with_index.map do |c, i|
          name = c["name"]
          Column.new(i, name, :json)
        end
        yield(task, columns)
      end

      def run(file_input)
        while file = file_input.next_file
          data = file.read
          if !data.nil? && !data.empty?
            item = Nokogiri::HTML.parse(data)
            dest = @task["schema"].inject([]) do |memo, schema|
              # https://github.com/shinjiikeda/embulk-filter-script_ruby/blob/master/lib/embulk/filter/script_ruby.rb
              preprocess = schema["elements"].map do |k, v|
                {k.to_sym => item.xpath(v["xpath"]).to_s.scan(Regexp.new(v["regexp"])).last }
              end
              # run func
              # string/array/hashのいずれかを返す
              value = preprocess
              binding.pry
              memo << value
            end
            @page_builder.add(dest)
          end
        end
        @page_builder.finish
      end
    end
  end
end
