# frozen_string_literal: true

class Api::V1::TasksController < AuthorizedApiController
  def create
    endpoint operation: Api::V1::Task::Operation::Create
  end

  def update
    endpoint operation: Api::V1::Task::Operation::Update
  end

  def destroy
    endpoint operation: Api::V1::Task::Operation::Destroy
  end
end
