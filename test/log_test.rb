require 'test_helper'

class LogTest < Test::Unit::TestCase
  
  should "save audit record" do
    assert_nothing_raised do
      Audit::Log.record(:Users, 1, timestamp, simple_change)
    end
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

  def timestamp
    Time.now.utc
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
