# frozen_string_literal: true

module Mutations
  module Comment
    class Destroy < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'destroyComment'
      description 'Destroys a comment'

      argument :id, ID, required: true

      field :result, String, null: false
      field :errors, [String], null: false

      def resolve(id:)
        Graphql::Comment::Operation::Destroy.call(current_user: current_user, id: id)[:result]
      end
    end
  end
end
