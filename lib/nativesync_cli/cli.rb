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
    def call(service_name, function_name)
      config = NativeSyncCli::Config.load
      ui = NativeSyncCli.ui

      credentials_name = delete options[:credentials_name]
      unless credentials_name.nil?
        credentials_name_param = "?credentials_name=#{credentials_name}"
      end

      params = options.map do |option|
        value = nil
        if (option =~ /[\/\w]+(\.)[\w]{0,4}/)
          value = IO.read(filename)
        else
          value = option
        end
        value
      end
      url = "/#{service_name}/#{function_name}#{credentials_name_param}"
      begin
        response = NativeSyncCli::Util.rest "post", url, params, config[:apikey]
        ui.info response
      rescue Exception => e
        ui.error e
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
