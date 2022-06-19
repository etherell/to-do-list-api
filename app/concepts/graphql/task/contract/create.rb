# frozen_string_literal: true

module Graphql::Task::Contract
  class Create < ApplicationContract
    property :description
    property :deadline

    validation :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?)
      required(:deadline).filled(:date_time?)
    end

    validation :size, if: :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?, size?: Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE)
    end
  end
end
