# frozen_string_literal: true

module Macro
  def self.RaiseError(status:, message: nil, **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      lambda { |ctx, **|
        error_message = if message
                          ctx[message]
                        elsif ctx['contract.default']&.errors.present?
                          ctx['contract.default'].errors.messages
                        end
        RaiseErrorService.call(status, error_message)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
