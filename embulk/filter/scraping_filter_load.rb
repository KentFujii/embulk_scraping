require 'pry'
require 'pry-nav'

module Embulk
  module Filter

    class ScrapingFilterLoad < FilterPlugin
      Plugin.register_filter('scraping_filter_load', self)

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
          dest = @task["schema"].inject([]) do |memo, schema|
            memo << schema['elements'].map { |e| [e, record[page.schema.find { |s| s.name == e }.index]] }.to_h
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
