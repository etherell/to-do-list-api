# frozen_string_literal: true

module Mutations
  module Task
    class Update < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'updateTask'
      description 'Updates a task'

      argument :description, String, required: true,
                                     prepare: ->(description, _ctx) { description.strip }
      argument :deadline, GraphQL::Types::ISO8601DateTime, required: true,
                                                           prepare: ->(deadline, _ctx) { DateTime.parse(deadline.to_s) }
      argument :position, Integer, required: true
      argument :is_done, Boolean, required: true
      argument :id, ID, required: true

      field :task, Types::TaskType, null: false
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::Task::Operation::Update.call(current_user: current_user, params: params)[:result]
      end
    end
  end
end
