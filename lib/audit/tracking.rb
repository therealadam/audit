module Audit::Tracking
  extend ActiveSupport::Concern
  
  included do
    before_update :audit
  end
  
  def audits
    Audit::Log.audits(audit_bucket, self.id)
  end
  
  def audit
    Audit::Log.record(audit_bucket, self.id, changes)
  end
  
  def audit_bucket
    self.class.name.pluralize.to_sym
  end
  
end