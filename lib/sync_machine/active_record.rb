require "active_record"
require "sync_machine"
require "sync_machine/active_record/adapter"
require "sync_machine/version"
require "wisper/active_record"

# A mini-framework for intelligently publishing complex model changes to an
# external API.
module SyncMachine
  def self.orm_adapter
    SyncMachine::ActiveRecord::Adapter
  end

  # ActiveRecord-specific functionality for SyncMachine.
  module ActiveRecord
    def self.extended(base)
      SyncMachine.extended(base)
      base.extend SyncMachine
    end
  end
end

Wisper::ActiveRecord.extend_all
