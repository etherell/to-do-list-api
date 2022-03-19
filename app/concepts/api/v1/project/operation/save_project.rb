# frozen_string_literal: true

module Api::V1::Project::Operation
  class SaveProject < ApplicationOperation
    pass Macro::PrepareParams(main_key: :project)
    step Contract::Build(constant: Api::V1::Project::Contract::Save)
    step Contract::Validate(key: :project)
    step Contract::Persist()
    pass :set_serializer

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Show.new(model)
    end
  end
end
