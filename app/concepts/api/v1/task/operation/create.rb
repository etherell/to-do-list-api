# frozen_string_literal: true

module Api::V1::Task::Operation
  class Create < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_project
    fail Macro::Semantic(failure: :not_found)
    pass :set_model
    pass Macro::PrepareParams(main_key: :task)
    step Contract::Build(constant: Api::V1::Task::Contract::Save)
    step Contract::Validate(key: :task)
    step Contract::Persist()
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def set_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.find_by(id: params[:project_id])
    end

    def set_model(ctx, project:, **)
      ctx[:model] = project.tasks.build
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Task::Serializer::Show.new(model)
    end
  end
end
