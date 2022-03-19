# frozen_string_literal: true

module Api::V1::Comment::Operation
  class Create < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_task
    fail Macro::Semantic(failure: :not_found)
    pass :set_model
    pass Macro::PrepareParams(main_key: :comment)
    step Contract::Build(constant: Api::V1::Comment::Contract::Create)
    step Contract::Validate(key: :comment)
    step Contract::Persist()
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def set_task(ctx, current_user:, params:, **)
      ctx[:task] = current_user.tasks.find_by(id: params[:task_id])
    end

    def set_model(ctx, task:, **)
      ctx[:model] = task.comments.build
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Comment::Serializer::Show.new(model)
    end
  end
end
