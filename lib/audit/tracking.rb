# Methods for tracking changes to your models by creating audit records
# for every atomic change. Including this module adds callbacks which create
# audit records every time a model object is changed and saved.
module Audit::Tracking
  extend ActiveSupport::Concern
  
  included do
    before_update :audit
  end
  
  # Public: fetch audit records for a model object.
  #
  # Returns an Array of Changeset objects.
  def audits
    Audit::Log.audits(audit_bucket, self.id)
  end
  
  # Creates a new audit record for this model object using data returned by 
  # ActiveRecord::Base#changes.
  #
  # Returns nothing.
  def audit
    Audit::Log.record(audit_bucket, self.id, changes)
  end
  
  # Generates the bucket name for the model class.
  #
  # Returns a Symbol-ified and pluralized version of the model's name.
  def audit_bucket
    self.class.name.pluralize.to_sym
  end
  
end
