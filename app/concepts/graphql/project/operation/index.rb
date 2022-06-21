# frozen_string_literal: true

module Graphql::Project::Operation
  class Index < ApplicationOperation
    pass :set_relation

    def set_relation(ctx, current_user:, **)
      ctx[:relation] = current_user.projects.lazy_preload(tasks: :comments)
    end
  end
end
