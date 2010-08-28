require 'common'
require 'audit'

if __FILE__ == $PROGRAM_NAME
  log = Audit::Log
  log.connection = Cassandra.new('Audit')
  
  changes = {:age => [30, 31]}
  log.record(:user, 1, changes)
  p log.audits(:user, 1)
end
