# frozen_string_literal: true

module Resolvers
  module Projects
    class Index < Resolvers::BaseResolver
      include Lib::UserAuthenticatable

      type [Types::ProjectType], null: true

      description 'Returns a list of current user projects'

      def resolve
        Graphql::Project::Operation::Index.call(current_user: current_user)[:relation]
      end
    end
  end
end
