module Interkassa
  autoload :Configuration, 'interkassa/configuration'
  autoload :Version,       'interkassa/version'
end

require 'interkassa/engine'
require 'interkassa/routing'