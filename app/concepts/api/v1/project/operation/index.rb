# frozen_string_literal: true

module Api::V1::Project::Operation
  class Index < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    pass :set_relation
    pass :search
    pass :set_serializer
    step Macro::Semantic(success: :ok)

    def set_relation(ctx, current_user:, **)
      ctx[:relation] = current_user.projects
    end

    def search(ctx, relation:, params:, **)
      return if params[:search].blank?

      ctx[:relation] = relation.search_by_title(params[:search])
    end

    def set_serializer(ctx, relation:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Index.new(relation)
    end
  end
end
