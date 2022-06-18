# frozen_string_literal: true

module Mutations
  module Session
    class Destroy < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      field :result, String, null: true
      field :errors, [String], null: false

      def resolve
        Graphql::Session::Operation::Destroy.call(refresh_token: refresh_token)[:result]
      end

      private

      def refresh_token
        context[:refresh_token]
      end
    end
  end
end
