# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::User::Create
    field :create_session, mutation: Mutations::Session::Create
    field :destroy_session, mutation: Mutations::Session::Destroy
    field :create_project, mutation: Mutations::Project::Create
    field :destroy_project, mutation: Mutations::Project::Destroy
    field :update_project, mutation: Mutations::Project::Update
  end
end
