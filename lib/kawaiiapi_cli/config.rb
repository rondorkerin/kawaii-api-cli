module KawaiiApiCli
  class Config
    class << self
      def set(config)
        @config = config
        path = File.expand_path('~/.kawaiiapi.yml')
        File.open(path, "w+") do |file|
          file.write(config.to_yaml)
        end
      end

      def load
        path = File.expand_path('~/.kawaiiapi.yml')
        raise "please use `ns login` or `ns signup` before attempting to use the API." unless (File.exist? path)
        @config = YAML.load_file(path)
        puts @config
        @config
      end

      def include?(key)
        @config.include?(key)
      end

      def [](key)
        @config[key]
      end

      def to_yaml
        @config.to_yaml
      end
    end
  end
end
