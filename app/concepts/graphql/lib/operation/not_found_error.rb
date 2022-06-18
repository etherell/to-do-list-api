# frozen_string_literal: true

module Graphql::Lib::Operation
  class NotFoundError < ApplicationOperation
    step :raise_not_found_error

    def raise_not_found_error(_ctx, model_name:, **)
      raise GraphQL::ExecutionError.new(
        I18n.t('errors.not_found', model_name: model_name),
        options: { status: :not_found, code: 404 }
      )
    end
  end
end
