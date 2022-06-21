# frozen_string_literal: true

module Graphql::Comment::Operation
  class Create < ApplicationOperation
    step :set_task
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)
    pass :set_model
    step Contract::Build(constant: Graphql::Comment::Contract::Create)
    step Contract::Validate()
    fail Macro::RaiseError(status: :unprocessable_entity)
    step Contract::Persist()
    pass :set_result

    def set_task(ctx, current_user:, params:, **)
      ctx[:task] = current_user.tasks.find_by(id: params[:task_id])
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Task.to_s)
    end

    def set_model(ctx, task:, **)
      ctx[:model] = task.comments.build
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { comment: model, errors: [] }
    end
  end
end
