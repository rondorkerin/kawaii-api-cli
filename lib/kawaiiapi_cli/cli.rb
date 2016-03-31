require 'thor'
require 'erubis'
require 'kawaiiapi_cli'
require 'kawaiiapi_cli/version'
require 'json'
require 'yaml'

module KawaiiApiCli
  class CLI < Thor
    map "-v" => "version"
    map "--version" => "version"

    desc "version", "print version"
    long_desc <<-D
      Print the KawaiiApi CLI tool version
    D
    def version
      KawaiiApiCli.ui.info "KawaiiApi CLI version %s" % [KawaiiApiCli::VERSION]
    end

    desc "call [SERVICE_NAME] [FUNCTION_NAME]", "Call a kawaiiapi function"
    method_option :credentials_name, :aliases => "-c", :desc => "name of the service credentials to use"
    def call(service_name, function_name, *args)
      config = KawaiiApiCli::Config.load
      ui = KawaiiApiCli.ui

      params = {}
      query = ""
      args.each do |arg|
        key, value = arg.split('=')
        params[key] = value
      end
      if (options[:credentials_name])
          query = "?credentials_name=#{options[:credentials_name]}" # hurts me more than it hurts you.
      end

      url = "/#{service_name}/#{function_name}#{query}"

      ui.info "posting to #{url} with params #{params.to_s} and api_key #{config['apikey']}"

      begin
        response = KawaiiApiCli::Util.rest "post", url, params, config['apikey']
        if (options[:output])
          IO.write(File.expand_path(options[:output]), JSON.pretty_generate(response))
        else
          ui.info JSON.pretty_generate(response)
        end
      rescue Exception => e
        ui.error e
      end
    end

    map "-f" => "file"
    map "--file" => "file"
    desc "deploy", "Deploy code to kawaiiapi"
    def deploy()
      begin
        config = YAML.load("#{Dir.pwd}/nsconfig.yml")
      rescue Exception => e
        ui.error "nsconfig.yml is not a valid YAML file"
      end
      if (options[:file])
        files_to_upload = {options[:file] => config[options[:file]]}
      else
        files_to_upload = config
      end
      continue = ask("About to upload #{files_to_upload.length} files. Are you sure? Y/n")
      exit if continue != "y" and continue != "Y"
      files_to_upload.each do |file_path, file_config|
        program = IO.read(File.expand_path(file_path))
        ui.info "Uploading file #{file_path} to function named #{config[:function_name]}"
        begin
          response = call('kawaiiapi', 'upload_cloud_function', "function_name=#{config[:function_name]}",
             "schedule=#{config[:schedule]}", "language=#{config[:language]}", "description=#{config[:description]}", "program=#{program}")
          ui.info response
        rescue Exception => e
          ui.error e
        end
      end

    end

    desc "login", "Login to kawaiiapi"
    def login
      ui = KawaiiApiCli.ui
      email = ask("What is your email?")
      password = ask("What is your password?", :echo => false)
      options = {
        email: email,
        password: password
      }
      begin
        response = KawaiiApiCli::Util.rest "post", "/kawaiiapi/login", options
        ui.success "Your config info has been saved to ~/.kawaiiapi.yml"
        KawaiiApiCli::Config.set(response)
      rescue Exception => e
        ui.error e
      end
    end

    desc "signup", "Signup for kawaiiapi"
    def signup
      ui = KawaiiApiCli.ui
      email = ask("What is your email?")
      company_name = ask("What is your company name?")
      company_secret = ask("What is your company secret passphrase? (if you are the first, make one up)")
      password = ask("What is your password?", :echo => false)
      options = {
        email: email,
        password: password,
        company_name: company_name,
        company_secret: company_secret
      }
      begin
        response = KawaiiApiCli::Util.rest "post", "/kawaiiapi/signup", options
        ui.success "Your config info has been saved to ~/.kawaiiapi.yml"
        KawaiiApiCli::Config.set(response)
      rescue Exception => e
        ui.error e
      end
    end

    desc "compile", "compile api_specs into kawaii_sdk.json"
    def compile
      sdk_api_spec_template = File.read('api_specs/templates/sdk.yml.erb')
      client_api_spec_template = File.read('api_specs/templates/service.yml.erb')
      api_spec_partials = []
      Dir['api_specs/partials/*'].each do |file_name|
        next if File.directory? file_name
        partial_yaml = YAML.load_file(file_name)
        api_spec_partials << partial_yaml
      end
      kawaii_sdk_yaml =  Erubis::Eruby.new(sdk_api_spec_template).result({'api_spec_partials' => api_spec_partials})
      File.open('api_specs/yml/kawaii_sdk.yml', 'w') { |file| file.write(kawaii_sdk_yaml) }
      File.open('api_specs/json/kawaii_sdk.json', 'w') { |file| file.write(YAML.load(kawaii_sdk_yaml).to_json) }
      File.open('kawaii_sdk.json', 'w') { |file| file.write(YAML.load(kawaii_sdk_yaml).to_json) }
    end
  end
end
