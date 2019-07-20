module Embulk
  module Output
    class ScrapingFormatter < OutputPlugin
      Plugin.register_output('scraping_formatter', self)

      def self.transaction(config, schema, count, &control)
        task = {
          'message' => config.param('message', :string, default: "record")
        }
        yield(task)
        next_config_diff = {}
        return next_config_diff
      end

      def add(page)
        page.each do |record|
          STDOUT.write(schema.names.zip(record).to_h.to_json + "\n")
        end
      end
    end
  end
end
