# frozen_string_literal: true

module Mutations
  module Project
    class Update < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'updateProject'
      description 'Updates project'

      argument :title, String, required: true, prepare: ->(title, _ctx) { title.strip }
      argument :id, ID, required: true

      field :project, Types::ProjectType, null: false
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::Project::Operation::Update.call(current_user: current_user, params: params)[:result]
      end
    end
  end
end
