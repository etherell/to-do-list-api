# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :projects, resolver: Resolvers::Projects::Index
    field :project, resolver: Resolvers::Projects::Show
  end
end
