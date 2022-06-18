# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_project, mutation: Mutations::Project::Create
    field :destroy_project, mutation: Mutations::Project::Destroy
    field :update_project, mutation: Mutations::Project::Update
  end
end
