require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'shoulda'
require 'cassandra'
require 'cassandra/mock'
require 'active_record'
require 'audit'

class Test::Unit::TestCase
  
  def setup
    super
    Audit::Log.connection = Cassandra::Mock.new(
      'Audit', 
      File.join(File.dirname(__FILE__), 'storage-conf.xml')
    )
  end
  
end
