require 'common'
require 'pp'
require 'audit'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :username, :null => false
    t.integer :age, :null => false
    t.integer :gizmo
  end
end

class User < ActiveRecord::Base
  include Audit::Tracking
end

if __FILE__ == $PROGRAM_NAME
  Audit::Log.connection = Cassandra.new('Audit')
  Audit::Log.clear!

  user = User.create(:username => 'adam', :age => 30)
  user.update_attributes(:age => 31)
  user.update_attributes(:username => 'akk')
  
  user.audit_metadata(:reason => "Canonize usernames")
  user.update_attributes(:username => 'therealadam')

  100.times.each { |i| user.update_attributes(:gizmo => i) }
  
  pp user.audits
end
