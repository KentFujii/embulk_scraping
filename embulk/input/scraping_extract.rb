require "nokogiri"
require 'pry'
require 'pry-nav'

module Embulk
  module Input
    class ScrapingExtract < InputPlugin
      Plugin.register_input('scraping_extract', self)

      def self.transaction(config, &control)
        files = Dir.glob(config.param("path_data", :string) + "/*")
        require config.param("path_script", :string)
        schema = config.param("schema", :array)
        task = {
          :files => files,
          :schema => schema
        }
        columns = schema.each_with_index.map do |c, i|
          name = c["name"]
          Column.new(i, name, :json)
        end
        yield(task, columns, files.length)
        next_config_diff = {}
        return next_config_diff
      end

      def initialize(task, schema, index, page_builder)
        super
        @file = task['files'][index]
      end

      def run
        data = File.read(@file)
        if !data.nil? && !data.empty?
          item = Nokogiri::HTML.parse(data)
          dest = @task["schema"].inject([]) do |memo, schema|
            # https://github.com/shinjiikeda/embulk-filter-script_ruby/blob/master/lib/embulk/filter/script_ruby.rb
            # https://github.com/takumakanari/embulk-parser-xml/blob/master/lib/embulk/parser/xpath.rb
            next memo << nil if schema["func"] == "none"
            raw_hash = schema["elements"].map do |k, v|
              [k, item.xpath(v["xpath"]).map { |e| e.to_s.scan(Regexp.new(v["regexp"])) }.flatten]
            end.to_h
            case schema["func"]
            when "string" then
              value = string_func(raw_hash)
            when "list" then
              value = list_func(raw_hash)
            when "callback" then
              value = callback_func(raw_hash, schema["name"])
            end
            memo << value
          end
          @page_builder.add(dest)
        end
        @page_builder.finish
        task_report = {}
        return task_report
      end

      private

      def string_func(raw_hash)
        raw_hash.map { |k, v| v }.flatten.join
      end

      def list_func(raw_hash)
        raw_hash.map { |k, v| v }.flatten.compact
      end

      def callback_func(raw_hash, name)
        method(name).call(raw_hash)
      end
    end
  end
end
