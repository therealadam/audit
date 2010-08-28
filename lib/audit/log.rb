require 'cassandra'
require 'active_support/core_ext/class'
require 'simple_uuid'

#TODO: TomDoc this mofo
class Audit::Log
  
  cattr_accessor :connection
  
  def self.record(bucket, key, changes)
    # TODO: Use a timestamp here?
    payload = {SimpleUUID::UUID.new.to_guid => JSON.dump(changes)}
    connection.insert(:Audits, "#{bucket}:#{key}", payload)
  end
  
  def self.audits(bucket, key)
    payload = connection.get(:Audits, "#{bucket}:#{key}")
    payload.values.map { |p| JSON.load(p) }
  end
  
end
