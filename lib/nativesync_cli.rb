require 'yaml'
require 'active_support/all'

module NativeSyncCli
  class << self
    attr_accessor :ui
  end

  autoload :Config,                   'nativesync_cli/config'
  autoload :ResponseCodeException,    'nativesync_cli/exception/response_code_exception'
  autoload :UI,                       'nativesync_cli/ui'
  autoload :Util,                     'nativesync_cli/util'
  autoload :Version,                  'nativesync_cli/version'

  NativeSyncCli.ui = STDOUT.tty? ? NativeSyncCli::UI::Color.new : NativeSyncCli::UI::Basic.new

  # 3rd Party Gems
  autoload :Shellwords,       'shellwords'
end
