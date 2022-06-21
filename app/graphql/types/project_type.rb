# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false
    field :title, String, null: false
    field :user, UserType, null: false
    field :tasks, [TaskType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
