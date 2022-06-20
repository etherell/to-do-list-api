# frozen_string_literal: true

module Graphql::Comment::Operation
  class Destroy < ApplicationOperation
    step :set_model_name
    step :set_task
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)
    pass :destroy_comment
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = Comment.to_s
    end

    def set_task(ctx, current_user:, id:, **)
      ctx[:task] = current_user.tasks.joins(:comments).find_by('comments.id': id)
    end

    def set_model(ctx, task:, id:, **)
      ctx[:model] = task.comments.find_by(id: id)
    end

    def destroy_comment(_ctx, model:, **)
      model.destroy
    end

    def set_result(ctx, **)
      ctx[:result] = { result: :completed, errors: [] }
    end
  end
end
