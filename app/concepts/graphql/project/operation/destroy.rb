# frozen_string_literal: true

module Graphql::Project::Operation
  class Destroy < ApplicationOperation
    step :set_model_name
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)
    pass :destroy_task
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = Project.to_s
    end

    def set_model(ctx, current_user:, id:, **)
      ctx[:model] = current_user.projects.find_by(id: id)
    end

    def destroy_task(_ctx, model:, **)
      model.destroy
    end

    def set_result(ctx, **)
      ctx[:result] = { result: :completed, errors: [] }
    end
  end
end
