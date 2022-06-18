# frozen_string_literal: true

module Graphql::Project::Operation
  class Show < ApplicationOperation
    step :set_model_name
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)

    def set_model_name(ctx, **)
      ctx[:model_name] = Project.to_s
    end

    def set_model(ctx, current_user:, id:, **)
      ctx[:model] = current_user.projects.find_by(id: id)
    end
  end
end
