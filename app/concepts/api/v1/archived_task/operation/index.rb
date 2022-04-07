# frozen_string_literal: true

module Api::V1::ArchivedTask::Operation
  class Index < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    pass :set_relation
    pass :set_serializer
    step Macro::Semantic(success: :ok)

    def set_relation(ctx, current_user:, **)
      ctx[:relation] = current_user.archived_tasks
    end

    def set_serializer(ctx, relation:, **)
      ctx[:serializer] = Api::V1::ArchivedTask::Serializer::Index.new(relation)
    end
  end
end
