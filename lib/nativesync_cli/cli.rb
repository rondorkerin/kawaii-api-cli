require 'thor'
require 'nativesync_cli'
require 'nativesync_cli/version'
require 'json'
require 'yaml'

module NativeSyncCli
  class CLI < Thor
    map "-v" => "version"
    map "--version" => "version"

    desc "version", "print version"
    long_desc <<-D
      Print the NativeSync CLI tool version
    D
    def version
      NativeSyncCli.ui.info "NativeSync CLI version %s" % [NativeSyncCli::VERSION]
    end

    desc "call [SERVICE_NAME] [FUNCTION_NAME]", "Call a nativesync function"
    method_option :credentials_name, :aliases => "-c", :desc => "name of the service credentials to use"
    def call(service_name, function_name, *args)
      config = NativeSyncCli::Config.load
      ui = NativeSyncCli.ui

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
        response = NativeSyncCli::Util.rest "post", url, params, config['apikey']
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
    desc "deploy", "Deploy code to nativesync"
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
          response = call('nativesync', 'upload_cloud_function', "function_name=#{config[:function_name]}",
             "schedule=#{config[:schedule]}", "language=#{config[:language]}", "description=#{config[:description]}", "program=#{program}")
          ui.info response
        rescue Exception => e
          ui.error e
        end
      end

    end

    desc "login", "Login to nativesync"
    def login
      ui = NativeSyncCli.ui
      email = ask("What is your email?")
      password = ask("What is your password?", :echo => false)
      options = {
        email: email,
        password: password
      }
      begin
        response = NativeSyncCli::Util.rest "post", "/nativesync/login", options
        ui.success "Your config info has been saved to ~/.nativesync.yml"
        NativeSyncCli::Config.set(response)
      rescue Exception => e
        ui.error e
      end
    end

    desc "signup", "Signup for nativesync"
    def signup
      ui = NativeSyncCli.ui
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
        response = NativeSyncCli::Util.rest "post", "/nativesync/signup", options
        ui.success "Your config info has been saved to ~/.nativesync.yml"
        NativeSyncCli::Config.set(response)
      rescue Exception => e
        ui.error e
      end
    end
  end
end
