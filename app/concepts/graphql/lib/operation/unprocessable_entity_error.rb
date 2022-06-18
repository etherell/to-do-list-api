# frozen_string_literal: true

module Graphql::Lib::Operation
  class UnprocessableEntityError < ApplicationOperation
    step :raise_unprocessable_error

    def raise_unprocessable_error(ctx, **)
      raise GraphQL::ExecutionError.new(
        ctx['contract.default'].errors.messages,
        options: { status: :unprocessable_entity, code: 422 }
      )
    end
  end
end
