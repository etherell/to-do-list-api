# frozen_string_literal: true

module Graphql::Task::Operation
  class Update < ApplicationOperation
    step :set_model
    fail :set_error_message
    fail Macro::RaiseError(status: :not_found, message: :not_found_error)
    step Contract::Build(constant: Graphql::Task::Contract::Update)
    step Contract::Validate()
    fail Macro::RaiseError(status: :unprocessable_entity)
    step Contract::Persist()
    pass :set_result

    def set_error_message(ctx, **)
      ctx[:not_found_error] = I18n.t('errors.not_found', model_name: Task.to_s)
    end

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.find_by(id: params[:id])
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { task: model, errors: [] }
    end
  end
end
