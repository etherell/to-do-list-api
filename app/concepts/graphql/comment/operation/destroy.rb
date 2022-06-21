# frozen_string_literal: true

module Graphql::Comment::Operation
  class Destroy < ApplicationOperation
    step :set_task
    step :set_model
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)
    pass :destroy_comment
    pass :set_result

    def set_task(ctx, current_user:, id:, **)
      ctx[:task] = current_user.tasks.joins(:comments).find_by('comments.id': id)
    end

    def set_model(ctx, task:, id:, **)
      ctx[:model] = task.comments.find_by(id: id)
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Comment.to_s)
    end

    def destroy_comment(_ctx, model:, **)
      model.destroy
    end

    def set_result(ctx, **)
      ctx[:result] = { result: :completed, errors: [] }
    end
  end
end
