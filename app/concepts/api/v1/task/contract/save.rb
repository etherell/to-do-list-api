# frozen_string_literal: true

module Api::V1::Task::Contract
  class Save < ApplicationContract
    property :description

    validation :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?)
    end

    validation :size, if: :default do
      configure { config.namespace = :task }

      required(:description).filled(:str?, size?: Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE)
    end
  end
end
