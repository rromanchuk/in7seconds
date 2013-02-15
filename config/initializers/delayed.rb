#Delayed::Worker.max_attempts = 3

require 'active_record/version'
module Delayed
  module Backend
    module ActiveRecord
      # A job object that is persisted to the database.
      # Contains the work object as a YAML field.
      class Job < ::ActiveRecord::Base
        #include Delayed::Backend::Base

        if ::ActiveRecord::VERSION::MAJOR < 4 || ::ActiveRecord.constants.include?(:MassAssignmentSecurity)
          attr_accessible :priority, :run_at, :queue, :payload_object,
                          :failed_at, :locked_at, :locked_by
        end
      end
    end
  end
end