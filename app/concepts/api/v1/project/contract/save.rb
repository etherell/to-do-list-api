# frozen_string_literal: true

module Api::V1::Project::Contract
  class Save < ApplicationContract
    property :title

    validation :default do
      configure { config.namespace = :project }

      required(:title).filled(:str?)
    end

    validation :size, if: :default do
      configure { config.namespace = :project }

      required(:title).filled(:str?, size?: Constants::Shared::PROJECT_TITLE_SIZE_RANGE)
    end
  end
end
