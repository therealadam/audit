require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'cassandra/0.7'
require 'cassandra/mock'
require 'active_record'
require 'audit'

if ENV["CASSANDRA"] == "Y"
  puts "-- RUNNING TESTS AGAINST CASSANDRA --"
end

class Test::Unit::TestCase

  alias_method :original_setup, :setup
  def setup
    if ENV["CASSANDRA"] == "Y"
      Audit::Log.connection = Cassandra.new("Audit")
      Audit::Log.connection.clear_keyspace!
    else
      Audit::Log.connection = Cassandra::Mock.new(
        'Audit', 
        File.join(File.dirname(__FILE__), 'storage-conf.xml')
      )
    end
    original_setup
  end
  
end
