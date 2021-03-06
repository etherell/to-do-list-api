# frozen_string_literal: true

class Api::V1::CommentsController < AuthorizedApiController
  def create
    endpoint operation: Api::V1::Comment::Operation::Create
  end

  def destroy
    endpoint operation: Api::V1::Comment::Operation::Destroy
  end
end
