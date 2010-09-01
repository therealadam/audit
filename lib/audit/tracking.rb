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
    # TODO: handle nil @audit_metadata
    data = {"changes" => changes, "metadata" => @audit_metadata}
    Audit::Log.record(audit_bucket, self.id, data)
  end
  
  # Generates the bucket name for the model class.
  #
  # Returns a Symbol-ified and pluralized version of the model's name.
  def audit_bucket
    self.class.name.pluralize.to_sym
  end
  
  # Public: Store audit metadata for the next write.
  #
  # metadata - a Hash of data that is written alongside the change data
  #
  # Returns nothing.
  def audit_metadata(metadata={})
    @audit_metadata = @audit_metadata.try(:update, metadata) || metadata
  end
  
end
