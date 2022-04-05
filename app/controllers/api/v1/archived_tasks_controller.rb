# frozen_string_literal: true

class Api::V1::ArchivedTasksController < AuthorizedApiController
  def index
    endpoint operation: Api::V1::ArchivedTask::Operation::Index
  end
end
