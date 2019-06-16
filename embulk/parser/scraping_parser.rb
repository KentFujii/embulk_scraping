require "nokogiri"
require 'pry'
require 'pry-nav'

module Embulk
  module Parser
    class ScrapingParser < ParserPlugin
      Plugin.register_parser("scraping_parser", self)

      def self.transaction(config, &control)
        schema = config.param("schema", :array)
        task = {
          :schema => schema,
        }
        columns = schema.each_with_index.map do |c, i|
          name = c["name"]
          Column.new(i, name, c["type"].to_sym)
        end
        yield(task, columns)
      end

      def run(file_input)
        binding.pry
        # while file = file_input.next_file
        #   data = file.read
        #   if !data.nil? && !data.empty?
        #     Nokogiri::XML(data).xpath(@task["root"], @task["namespaces"]).each do |item|
        #       dest = @task["schema"].inject([]) do |memo, schema|
        #         es = item.xpath(schema["path"], @namespaces)
        #         memo << convert(es.empty? ? nil : es.map(&:text), schema)
        #         memo
        #       end
        #       @page_builder.add(dest)
        #     end
        #   end
        # end
        # @page_builder.finish
      end

      # private
      # def convert(val, schema)
      #   v = if schema["type"] == "json"
      #     val.nil? ? nil : val
      #   else
      #     val.nil? ? "" : val.join("")
      #   end
      #   case schema["type"]
      #   when "string", "json"
      #     v
      #   when "long"
      #     v.to_i
      #   when "double"
      #     v.to_f
      #   when "boolean"
      #     ["yes", "true", "1"].include?(v.downcase)
      #   when "timestamp"
      #     unless v.empty?
      #       dest = Time.strptime(v, schema["format"])
      #       utc_offset = dest.utc_offset
      #       zone_offset = Time.zone_offset(schema["timezone"])
      #       dest.localtime(zone_offset) + utc_offset - zone_offset
      #     else
      #       nil
      #     end
      #   else
      #     raise "Unsupported type '#{type}'"
      #   end
      # end
    end
  end
end
