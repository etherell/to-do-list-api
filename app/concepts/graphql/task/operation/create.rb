# frozen_string_literal: true

module Graphql::Task::Operation
  class Create < ApplicationOperation
    step :set_project
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error), fail_fast: true
    pass :set_model
    step Contract::Build(constant: Graphql::Task::Contract::Create)
    step Contract::Validate()
    fail Macro::RaiseError(status: :unprocessable_entity)
    step Contract::Persist()
    pass :set_result

    def set_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.find_by(id: params[:project_id])
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Project.to_s)
    end

    def set_model(ctx, project:, **)
      ctx[:model] = project.tasks.build
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { task: model, errors: [] }
    end
  end
end
