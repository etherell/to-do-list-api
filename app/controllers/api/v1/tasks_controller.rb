# frozen_string_literal: true

class Api::V1::TasksController < AuthorizedApiController
  def create
    endpoint operation: Api::V1::Task::Operation::Create
  end
end
