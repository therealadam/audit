require 'active_support/core_ext/module'

# Methods for tracking changes to your models by creating audit records
# for every atomic change. Including this module adds callbacks which create
# audit records every time a model object is changed and saved.
module Audit::Tracking
  extend ActiveSupport::Concern

  # Public: set the log object to track changes with.
  #
  # Returns the log object currently in use.
  mattr_accessor :log
  self.log = Audit::Log
  
  included do
    before_update :audit
  end
  
  # Public: fetch audit records for a model object.
  #
  # Returns an Array of Changeset objects.
  def audits
    Audit::Tracking.log.audits(audit_bucket, self.id)
  end
  
  # Creates a new audit record for this model object using data returned by 
  # ActiveRecord::Base#changes.
  #
  # Returns nothing.
  def audit
    data = {"changes" => changes, "metadata" => audit_metadata}
    Audit::Tracking.log.record(audit_bucket, self.id, data)
    @audit_metadata = {}
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
