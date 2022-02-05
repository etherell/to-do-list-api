# frozen_string_literal: true

module Macro
  def self.PrepareParams(main_key:, secondary_key: nil, specific_keys: [], **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      lambda { |ctx, **|
        PrepareParamsService.prepare(ctx[:params],
                                     main_key: main_key,
                                     secondary_key: secondary_key,
                                     specific_keys: specific_keys)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
