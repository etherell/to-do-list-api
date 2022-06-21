# frozen_string_literal: true

module Graphql::Project::Operation
  class Destroy < ApplicationOperation
    step :set_model
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)
    pass :destroy_project
    pass :set_result

    def set_model(ctx, current_user:, id:, **)
      ctx[:model] = current_user.projects.find_by(id: id)
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Project.to_s)
    end

    def destroy_project(_ctx, model:, **)
      model.destroy
    end

    def set_result(ctx, **)
      ctx[:result] = { result: :completed, errors: [] }
    end
  end
end
