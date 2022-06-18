# frozen_string_literal: true

module Graphql::Lib::Operation
  class NotFoundError < ApplicationOperation
    step :raise_not_found_error

    def raise_not_found_error(_ctx, model_name:, **)
      raise GraphQL::ExecutionError.new("#{model_name} not found", options: { status: :not_found, code: 404 })
    end
  end
end
