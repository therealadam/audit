require 'test_helper'

class ChangesetTest < Test::Unit::TestCase
  
  should 'convert a hash of changes to a changeset' do
    changes = {"username" => ["akk", "adam"], "age" => [30, 31]}
    changeset = Audit::Changeset.from_hash(changes)
    
    assert_equal 2, changeset.changes.length
    assert changeset.changes.all? do |cs| 
      %w{username age}.include?(cs.attribute)
      ["akk", 30].include?(cs.old_value)
      ["adam", 31].include?(cs.new_value)
    end
  end
  
end
