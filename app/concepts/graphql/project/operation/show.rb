# frozen_string_literal: true

module Graphql::Project::Operation
  class Show < ApplicationOperation
    step :set_model
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)

    def set_model(ctx, current_user:, id:, **)
      ctx[:model] = current_user.projects.lazy_preload(tasks: :comments).find_by(id: id)
    end

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Project.to_s)
    end
  end
end
