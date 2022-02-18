# frozen_string_literal: true

module Api::V1::Project::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    pass :destroy_project
    pass Macro::Semantic(success: :destroyed)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def destroy_project(_ctx, model:, **)
      model.destroy
    end
  end
end
