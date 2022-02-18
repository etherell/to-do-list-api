# frozen_string_literal: true

module Api::V1::Project::Operation
  class Create < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    pass :set_model
    pass Macro::PrepareParams(main_key: :project)
    step Contract::Build(constant: Api::V1::Project::Contract::Save)
    step Contract::Validate(key: :project)
    step Contract::Persist()
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def set_model(ctx, current_user:, **)
      ctx[:model] = current_user.projects.build
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Show.new(model)
    end
  end
end
