require 'yaml'
require 'active_support/all'

module KawaiiApiCli
  class << self
    attr_accessor :ui
  end

  autoload :Config,                   'kawaiiapi_cli/config'
  autoload :ResponseCodeException,    'kawaiiapi_cli/exception/response_code_exception'
  autoload :UI,                       'kawaiiapi_cli/ui'
  autoload :Util,                     'kawaiiapi_cli/util'
  autoload :Version,                  'kawaiiapi_cli/version'

  KawaiiApiCli.ui = STDOUT.tty? ? KawaiiApiCli::UI::Color.new : KawaiiApiCli::UI::Basic.new

  # 3rd Party Gems
  autoload :Shellwords,       'shellwords'
end
