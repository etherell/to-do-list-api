# frozen_string_literal: true

module Graphql::Task::Operation
  class Create < ApplicationOperation
    step :set_mode_name
    step :set_project
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)
    pass :set_model
    step Contract::Build(constant: Graphql::Task::Contract::Create)
    step Contract::Validate()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError)
    step Contract::Persist()
    pass :set_result

    def set_mode_name(ctx, **)
      ctx[:model_name] = Project.to_s
    end

    def set_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.find_by(id: params[:project_id])
    end

    def set_model(ctx, project:, **)
      ctx[:model] = project.tasks.build
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { task: model, errors: [] }
    end
  end
end
