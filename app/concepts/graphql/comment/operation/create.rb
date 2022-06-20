# frozen_string_literal: true

module Graphql::Comment::Operation
  class Create < ApplicationOperation
    step :set_model_name
    step :set_task
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)
    pass :set_model
    step Contract::Build(constant: Graphql::Comment::Contract::Create)
    step Contract::Validate()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError)
    step Contract::Persist()
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = Task.to_s
    end

    def set_task(ctx, current_user:, params:, **)
      ctx[:task] = current_user.tasks.find_by(id: params[:task_id])
    end

    def set_model(ctx, task:, **)
      ctx[:model] = task.comments.build
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { comment: model, errors: [] }
    end
  end
end
