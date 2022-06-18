# frozen_string_literal: true

module Lib
  module UserAuthenticatable
    private

    def ready?(**_args)
      return true if current_user.present?

      raise GraphQL::ExecutionError.new('Not authorized', options: { status: :unauthorized, code: 401 })
    end

    def current_user
      context[:current_user]
    end
  end
end
