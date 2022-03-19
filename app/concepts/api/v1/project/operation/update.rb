# frozen_string_literal: true

module Api::V1::Project::Operation
  class Update < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_model
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step Subprocess(Api::V1::Project::Operation::SaveProject), fast_track: true
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end
  end
end
