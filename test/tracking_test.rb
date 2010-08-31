require "test_helper"

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

class User < ActiveRecord::Base; include Audit::Tracking; end

class TrackingTest < Test::Unit::TestCase
  
  def setup
    @model = User.new
  end
  
  context "generate an audit bucket name" do
    
    should "based on the model name" do
      assert_equal :Users, @model.audit_bucket
    end
    
  end
  
  should "add audit-related methods" do
    assert_equal %w{audit audit_bucket audits}, 
      @model.methods.map { |s| s.to_s }.grep(/audit/).sort
  end
  
end