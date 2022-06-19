# frozen_string_literal: true

module Graphql::Task::Operation
  class Update < ApplicationOperation
    step :set_model_name
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError)
    step Contract::Build(constant: Graphql::Task::Contract::Update)
    step Contract::Validate()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError)
    step Contract::Persist()
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = Task.to_s
    end

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.find_by(id: params[:id])
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { task: model, errors: [] }
    end
  end
end
