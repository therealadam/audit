require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'cassandra'
require 'cassandra/mock'
require 'active_record'
require 'audit'

class Test::Unit::TestCase

  alias_method :original_setup, :setup
  def setup
    Audit::Log.connection = Cassandra::Mock.new(
      'Audit', 
      File.join(File.dirname(__FILE__), 'storage-conf.xml')
    )
    original_setup
  end
  
end
