# frozen_string_literal: true

module Api::V1::Project::Operation
  class Update < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    step Subprocess(Api::V1::Project::Operation::SaveProject), fast_track: true
    pass :count_intime_percentage
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def count_intime_percentage(ctx, model:, **)
      done_tasks = model.tasks.done
      in_time_percentage = done_tasks.in_time.count / (done_tasks.count / 100.0).truncate(2)
      overdue_percantage = 100.0 - in_time_percentage
      ctx[:serializer_options] = {
        params: { in_time_percentage: in_time_percentage, overdue_percantage: overdue_percantage }
      }
    end

    def set_serializer(ctx, model:, serializer_options:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Update.new(model, serializer_options)
    end
  end
end
