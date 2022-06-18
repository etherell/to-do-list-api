# frozen_string_literal: true

module Graphql::Lib::Operation
  class ForbiddenError < ApplicationOperation
    step :raise_forbidden_error

    def raise_forbidden_error(_ctx, **)
      raise GraphQL::ExecutionError.new(
        'Please log in to access this page',
        options: { status: :forbidden, code: 403 }
      )
    end
  end
end
