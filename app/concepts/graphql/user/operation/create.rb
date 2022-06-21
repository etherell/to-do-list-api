# frozen_string_literal: true

module Graphql::User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    step Contract::Build(constant: Graphql::User::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()
    fail Macro::RaiseError(status: :unprocessable_entity)
    pass :set_result

    def set_result(ctx, model:, **)
      ctx[:result] = { user: model, errors: [] }
    end
  end
end
