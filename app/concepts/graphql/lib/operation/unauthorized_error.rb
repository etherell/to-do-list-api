# frozen_string_literal: true

module Graphql::Lib::Operation
  class UnauthorizedError < ApplicationOperation
    step :raise_unauthorized_error

    def raise_unauthorized_error(ctx, **)
      raise GraphQL::ExecutionError.new(
        ctx[:error_message],
        options: { status: :unauthorized, code: 401 }
      )
    end
  end
end
