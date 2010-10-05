# Audit is a system for tracking model changes outside of your application's 
# database.
module Audit
  
  # Everything needs a version.
  VERSION = '0.3.0'
  
  autoload :Log, "audit/log"
  autoload :Changeset, "audit/changeset"
  autoload :Tracking, "audit/tracking"
  
end
