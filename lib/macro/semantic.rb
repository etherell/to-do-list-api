# frozen_string_literal: true

module Macro
  def self.Semantic(success: nil, failure: nil, **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      lambda { |ctx, **|
        ctx[:semantic_success] = success
        ctx[:semantic_failure] = failure
        true
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
