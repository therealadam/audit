require 'helper'

class ChangesetTest < Test::Unit::TestCase
  
  should 'convert a hash of changes to a changeset' do
    metadata = {
      "reason" => "Canonize usernames, getting older",
      "signed" => "akk"
    }
    changes = {
      "changes" => {
        "username" => ["akk", "adam"], 
        "age" => [30, 31]
      },
      "metadata" => metadata
    }
    changeset = Audit::Changeset.from_enumerable(changes)
    
    assert_equal 2, changeset.changes.length
    assert(changeset.changes.all? { |cs| 
      %w{username age}.include?(cs.attribute)
      ["akk", 30].include?(cs.old_value)
      ["adam", 31].include?(cs.new_value)
    })
    assert_equal metadata, changeset.metadata
  end
  
  should "convert multile change records to an Array of Changesets" do
    changes = [
      {
        "changes" => {"username" => ["akk", "adam"], "age" => [30, 31]}, 
        "metadata" => {}
      },
      {
        "changes" => {
          "username" => ["adam", "therealadam"], 
          "age" => [31, 32]
        },
        "metadata" => {}
      }
      
    ]
    changesets = Audit::Changeset.from_enumerable(changes)
    
    assert_equal 2, changesets.length
  end
  
end
