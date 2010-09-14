require 'rest_client'
require 'crack/xml'
require File.expand_path(File.dirname(__FILE__) + '/enom/client')
require File.expand_path(File.dirname(__FILE__) + '/enom/domain')

module Enom
  class InterfaceError < StandardError; end
  class InvalidNameServerCount < StandardError; end
end
