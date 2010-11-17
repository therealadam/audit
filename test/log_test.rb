require 'test_helper'

class LogTest < Test::Unit::TestCase
  
  should "save audit record" do
    assert_nothing_raised do
      Audit::Log.record(:Users, 1, timestamp, simple_change)
    end
  end

  should "save audit records idempotently" do
    t = Time.now.utc.iso8601
    3.times { Audit::Log.record(:Users, 1, t, simple_change) }
    assert_equal 1, Audit::Log.audits(:Users, 1).length
  end
  
  should "load audit records" do
    Audit::Log.record(:Users, 1, timestamp, simple_change)
    assert_kind_of Audit::Changeset, Audit::Log.audits(:Users, 1).first
  end
  
  should "load audits with multiple changed attributes" do
    Audit::Log.record(:Users, 1, timestamp, multiple_changes)
    changes = Audit::Log.audits(:Users, 1).first.changes
    changes.each do |change|
      assert %w{username age}.include?(change.attribute)
      assert ["akk", 30].include?(change.old_value)
      assert ["adam", 31].include?(change.new_value)
    end
  end

  def teardown
    # FIXME: figure out how to properly clear a keyspace or CF
    Audit::Log.connection.remove(:Audits, "Users:1")
  end

  def timestamp
    Time.now.utc.iso8601
  end
  
  def simple_change
    {"changes" => {"username" => ["akk", "adam"]}, "metadata" => {}}
  end
  
  def multiple_changes
    {
      "changes" => {"username" => ["akk", "adam"], "age" => [30, 31]}, 
      "metadata" => {}
    }
  end
  
end
