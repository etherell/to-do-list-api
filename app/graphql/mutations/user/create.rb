# frozen_string_literal: true

module Mutations
  module User
    class Create < Mutations::BaseMutation
      description 'Creates new user'

      argument :username, String, required: true, prepare: ->(title, _ctx) { title.strip }
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :user, Types::UserType, null: false
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::User::Operation::Create.call(params: params)[:result]
      end
    end
  end
end
