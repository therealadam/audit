require 'cassandra'
require 'active_support/core_ext/module'
require 'simple_uuid'

#TODO: TomDoc this mofo
module Audit::Log
  
  mattr_accessor :connection
  
  def self.record(bucket, key, changes)
    payload = {SimpleUUID::UUID.new.to_guid => JSON.dump(changes)}
    connection.insert(:Audits, "#{bucket}:#{key}", payload)
  end
  
  def self.audits(bucket, key)
    payload = connection.get(:Audits, "#{bucket}:#{key}", :reversed => true)
    payload.values.map do |p|
      Audit::Changeset.from_hash(JSON.load(p))
    end
  end
  
  def self.clear!
    # It'd be nice if this could clear one bucket at a time
    connection.clear_keyspace!
  end
  
end
