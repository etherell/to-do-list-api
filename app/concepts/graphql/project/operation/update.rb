# frozen_string_literal: true

module Graphql::Project::Operation
  class Update < ApplicationOperation
    step :set_model
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)
    step Contract::Build(constant: Graphql::Project::Contract::Save)
    step Contract::Validate()
    step Contract::Persist()
    fail Macro::RaiseError(status: :unprocessable_entity)
    pass :set_result

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Project.to_s)
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { project: model, errors: [] }
    end
  end
end
