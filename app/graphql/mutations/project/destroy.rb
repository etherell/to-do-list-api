# frozen_string_literal: true

module Mutations
  module Project
    class Destroy < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'projectDestroy'
      description 'Destroys a project'

      argument :id, ID, required: true

      field :result, String, null: false
      field :errors, [String], null: false

      def resolve(id:)
        Graphql::Project::Operation::Destroy.call(current_user: current_user, id: id)[:result]
      end
    end
  end
end
