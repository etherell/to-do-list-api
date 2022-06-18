# frozen_string_literal: true

module Graphql::Project::Operation
  class Create < ApplicationOperation
    pass :set_model
    step Contract::Build(constant: Graphql::Project::Contract::Save)
    step Contract::Validate()
    step Contract::Persist()
    fail Subprocess(Graphql::Lib::Operation::UnprocessableEntityError)
    pass :set_result

    def set_model(ctx, current_user:, **)
      ctx[:model] = current_user.projects.build
    end

    def set_result(ctx, model:, **)
      ctx[:result] = { project: model, errors: [] }
    end
  end
end
