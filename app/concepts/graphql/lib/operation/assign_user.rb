# frozen_string_literal: true

module Graphql::Lib::Operation
  class AssignUser < ApplicationOperation
    step :current_user_present?
    fail Subprocess(Graphql::Lib::Operation::ForbiddenError)

    def current_user_present?(ctx, **)
      ctx[:current_user].present?
    end
  end
end
