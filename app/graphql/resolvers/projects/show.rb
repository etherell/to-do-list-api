# frozen_string_literal: true

module Resolvers
  module Projects
    class Show < Resolvers::BaseResolver
      include Lib::UserAuthenticatable

      type Types::ProjectType, null: false

      description 'Returns particular project of current user'

      argument :id, ID, required: true

      def resolve(id:)
        Graphql::Project::Operation::Show.call(current_user: current_user, id: id)[:model]
      end
    end
  end
end
