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
              xpath_processed = item.xpath(schema["path"])
              # regexp_processed = item.xpath(schema["regex"])
              # func_processed = 
              # es = item.xpath(schema["path"])
              binding.pry
              memo << es
              memo
            end
            @page_builder.add(dest)
          #   Nokogiri::XML(data).xpath(@task["root"], @task["namespaces"]).each do |item|
          #     dest = @task["schema"].inject([]) do |memo, schema|
          #       es = item.xpath(schema["path"], @namespaces)
          #       memo << convert(es.empty? ? nil : es.map(&:text), schema)
          #       memo
          #     end
          #   end
          end
        end
        @page_builder.finish
      end
    end
  end
end
