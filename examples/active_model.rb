# TODO: write me

require 'common'
require 'audit'
require 'active_model'

class User
  extend ActiveModel::Callbacks
  
  define_model_callbacks :create, :update
  after_update :bonk
  after_create :clown
  
  def self.create(attrs)
    new.create(attrs)
  end
  
  def create(attrs)
    _run_create_callbacks do
      puts "Creating: #{attrs}"
    end
  end
  
  def update(attrs)
    _run_update_callbacks do
      puts "Updating #{attrs}"
    end
  end
  
  def bonk
    puts 'bonk!'
  end
  
  def clown
    puts "clown!"
  end
  
end

if __FILE__ == $PROGRAM_NAME
  User.create(:foo)
end
