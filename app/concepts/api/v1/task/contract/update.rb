# frozen_string_literal: true

module Api::V1::Task::Contract
  class Update < ApplicationContract
    property :description
    property :deadline
    property :position
    property :is_done

    validation :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?)
      required(:deadline).filled(:date_time?)
      required(:position).filled(:int?)
      required(:is_done).filled(:bool?)
    end

    validation :size, if: :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?, size?: Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE)
    end
  end
end
