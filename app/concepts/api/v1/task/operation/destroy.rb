# frozen_string_literal: true

module Api::V1::Task::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_project
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    pass :destroy_task
    pass Macro::Semantic(success: :destroyed)

    def set_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.find_by(id: params[:project_id])
    end

    def set_model(ctx, project:, params:, **)
      ctx[:model] = project.tasks.find_by(id: params[:id])
    end

    def destroy_task(_ctx, model:, **)
      model.destroy
    end
  end
end
