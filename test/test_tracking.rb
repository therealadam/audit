require "helper"

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

  should "generate an audit bucket name based on the model name" do
    assert_equal :Users, @model.audit_bucket
  end
  
  should "track audit metadata for the next save" do
    audit_metadata = {"reason" => "Canonize usernames", "changed_by" => "JD"}
    user = User.create(:username => "adam", :age => 31)
    user.audit_metadata(audit_metadata)
    user.update_attributes(:username => "therealadam")
    changes = user.audits
    
    assert_equal audit_metadata, changes.first.metadata

    user.save!

    assert_equal({}, user.audit_metadata) # Should clear audit after write
  end

  should "add audit-related methods" do
    methods = %w{audit audit_bucket audit_metadata audits 
                 skip_audit skip_audit?}
    assert_equal methods, @model.methods.map { |s| s.to_s }.grep(/audit/).sort
  end

  should "set the log object to an arbitrary object" do
    Audit::Tracking.log = flexmock(:log).
      should_receive(:audits).
      once.
      mock

    User.create(:username => "Adam", :age => "31").audits

    Audit::Tracking.log = Audit::Log
  end

  should "disable audits for the one write" do
    user = User.create(:username => "adam", :age => 31)
    user.save!

    user.skip_audit
    user.update_attributes(:age => 32)
    assert_equal 1, user.audits.length
    assert !user.skip_audit?
  end
  
  should "revert the model to the state recorded by an audit" do
    user = User.create(:username => "adam", :age => 31)
    user.update_attributes(:username => "therealadam")

    user.revert_to(user.audits.first)

    assert_equal "adam", user.username
  end

  should "revert the model to the state represented by a series of changes" do
    user = User.create(:username => "adam", :age => 31)
    user.update_attributes(:username => "therealadam")
    user.update_attributes(:age => 32)
    user.update_attributes(:username => "akk")
    user.update_attributes(:age => 33)

    user.revert(user.audits[0, 4])
    assert_equal 31, user.age
    assert_equal "adam", user.username
  end

end
