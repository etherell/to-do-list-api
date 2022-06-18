# frozen_string_literal: true

module Graphql::Project::Operation
  class Index < ApplicationOperation
    pass :set_relation

    def set_relation(ctx, current_user:, **)
      ctx[:relation] = current_user.projects
    end
  end
end
