Audit::Change = Struct.new(:attribute, :old_value, :new_value)

class Audit::Changeset < Struct.new(:changes)
  
  def self.from_hash(hsh)
    changes = hsh.map do |k, v|
      attribute = k
      old_value = v.first
      new_value = v.last
      Audit::Change.new(attribute, old_value, new_value)
    end
    new(changes)
  end
  
end
