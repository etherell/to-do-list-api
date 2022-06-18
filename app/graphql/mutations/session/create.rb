# frozen_string_literal: true

module Mutations
  module Session
    class Create < Mutations::BaseMutation
      graphql_name 'createSession'
      description 'User sign in'

      argument :username, String, required: true, prepare: ->(username, _ctx) { username.strip }
      argument :password, String, required: true

      field :session, Types::SessionType, null: true
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::Session::Operation::Create.call(params: params)[:result]
      end
    end
  end
end
