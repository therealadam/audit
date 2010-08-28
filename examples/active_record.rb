require 'common'
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
  end
end

class User < ActiveRecord::Base
  
  before_update :audit
  
  def audits
    Audit::Log.audits(:Users, self.id)
  end
  
  protected
  
  def audit
    Audit::Log.record(:Users, self.id, changes)
  end
  
end

if __FILE__ == $PROGRAM_NAME
  Audit::Log.connection = Cassandra.new('Audit')
  user = User.create(:username => 'adam', :age => 30)
  user.update_attributes(:age => 31)
  p user.audits
end
