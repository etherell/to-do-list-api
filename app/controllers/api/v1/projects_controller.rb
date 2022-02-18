# frozen_string_literal: true

class Api::V1::ProjectsController < AuthorizedApiController
  def create
    endpoint operation: Api::V1::Project::Operation::Create
  end
end
