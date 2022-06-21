# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :project, ProjectType, null: false
    field :comments, [CommentType], null: true
    field :description, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :is_done, GraphQL::Types::Boolean, null: false
    field :deadline, GraphQL::Types::ISO8601DateTime, null: false
    field :position, Integer
    field :overdue_status, Integer
  end
end
