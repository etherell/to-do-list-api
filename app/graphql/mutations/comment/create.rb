# frozen_string_literal: true

module Mutations
  module Comment
    class Create < Mutations::BaseMutation
      include Lib::UserAuthenticatable

      graphql_name 'createComment'
      description 'Creates new comment'

      argument :text, String, required: true, prepare: ->(text, _ctx) { text.strip }
      argument :image, String, required: false
      argument :task_id, ID, required: true

      field :comment, Types::CommentType, null: false
      field :errors, [String], null: false

      def resolve(**params)
        Graphql::Comment::Operation::Create.call(current_user: current_user, params: params)[:result]
      end
    end
  end
end
