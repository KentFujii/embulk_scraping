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
              # https://github.com/takumakanari/embulk-parser-xml/blob/master/lib/embulk/parser/xpath.rb
              next memo << nil if schema["func"] == "none"
              preprocess = schema["elements"].map do |k, v|
                {k.to_sym => item.xpath(v["xpath"]).to_s.scan(Regexp.new(v["regexp"])).last }
              end
              # run func
              # string/array/hash/callbackのいずれかを返す
              value = preprocess
              memo << value
            end
            @page_builder.add(dest)
          end
        end
        @page_builder.finish
      end

      private

      def string_func
      end

      def array_func
      end

      def hash_func
      end

      def callback_func
      end
    end
  end
end
