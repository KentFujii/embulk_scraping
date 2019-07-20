require "nokogiri"
require 'pry'
require 'pry-nav'

module Embulk
  module Filter

    class ScrapingFilterExtract < FilterPlugin
      # filter plugin file name must be: embulk/filter/<name>.rb
      Plugin.register_filter('scraping_filter_extract', self)

      def self.transaction(config, in_schema, &control)
        require config.param("path_script", :string)
        schema = config.param("schema", :array)
        task = {
          :schema => config.param("schema", :array)
        }
        columns = schema.each_with_index.map do |c, i|
          name = c["name"]
          Column.new(i, name, :json)
        end
        yield(task, columns)
      end

      def add(page)
        page.each do |record|
          # ここにレコード追加
          dest = @task["schema"].inject([]) do |memo, schema|
            # dest = page.schema.inject([]) do |memo, schema|
            index = page.schema.find { |s| s.name == schema['name'] }.index
            value = method(schema['func']).call(record[index])
            memo << value
          end
          @page_builder.add(dest)
        end
      end

      def finish
        @page_builder.finish
      end
    end
  end
end
