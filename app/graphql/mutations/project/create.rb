# frozen_string_literal: true

module Mutations
  module Project
    class Create < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'projectCreate'
      description 'Creates new project'

      argument :title, String, required: true, prepare: ->(title, _ctx) { title.strip }

      field :project, Types::ProjectType, null: false
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::Project::Operation::Create.call(current_user: current_user, params: params)[:result]
      end
    end
  end
end
