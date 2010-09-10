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
    super
    @model = User.new
  end
  
  context "generate an audit bucket name" do
    
    should "based on the model name" do
      assert_equal :Users, @model.audit_bucket
    end
    
  end
  
  should "track audit metadata for the next save" do
    audit_metadata = {"reason" => "Canonize usernames", "changed_by" => "JD"}
    user = User.create(:username => "adam", :age => 31)
    user.audit_metadata(audit_metadata)
    user.update_attributes(:username => "therealadam")
    changes = user.audits
    
    assert_equal audit_metadata, changes.first.metadata
  end
  
  should "add audit-related methods" do
    assert_equal %w{audit audit_bucket audit_metadata audits}, 
      @model.methods.map { |s| s.to_s }.grep(/audit/).sort
  end

  should "set the log object to an arbitrary object" do
    Audit::Tracking.log = flexmock(:log).
      should_receive(:audits).
      once.
      mock

    User.create(:username => "Adam", :age => "31").audits

    Audit::Tracking.log = Audit::Log
  end
  
end
