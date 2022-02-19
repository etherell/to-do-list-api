# frozen_string_literal: true

module Api::V1::Comment::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Api::V1::Lib::Operation::AssignUser), fast_track: true
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    pass :destroy_comment
    pass Macro::Semantic(success: :destroyed)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.joins(:comments).find_by('comments.id': params[:id])
    end

    def destroy_comment(_ctx, model:, **)
      model.destroy
    end
  end
end
