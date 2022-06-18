# frozen_string_literal: true

module Graphql::Project::Operation
  class Update < ApplicationOperation
    step :set_model_name
    step :set_model
    fail Subprocess(Graphql::Lib::Operation::NotFoundError), fail_fast: true
    step Contract::Build(constant: Graphql::Project::Contract::Save)
    step Contract::Validate()
    step Contract::Persist()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError)
    pass :set_result

    def set_model_name(ctx, **)
      ctx[:model_name] = Project.to_s
    end

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { project: model, errors: [] }
    end
  end
end
