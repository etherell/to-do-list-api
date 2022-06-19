# frozen_string_literal: true

module Mutations
  module Task
    class Destroy < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'destroyTask'
      description 'Destroys a task'

      argument :id, ID, required: true

      field :result, String, null: false
      field :errors, [String], null: false

      def resolve(id:)
        Graphql::Task::Operation::Destroy.call(current_user: current_user, id: id)[:result]
      end
    end
  end
end
