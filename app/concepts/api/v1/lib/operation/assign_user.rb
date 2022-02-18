# frozen_string_literal: true

module Api::V1::Lib::Operation
  class AssignUser < ApplicationOperation
    step :current_user_present?
    fail Macro::Semantic(failure: :forbidden), fail_fast: true

    def current_user_present?(ctx, **)
      ctx[:current_user].present?
    end
  end
end
