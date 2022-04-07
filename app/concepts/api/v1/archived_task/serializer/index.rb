# frozen_string_literal: true

module Api::V1::ArchivedTask::Serializer
  class Index < ApplicationSerializer
    attribute :description, :position, :is_done, :deadline

    set_type :task
  end
end
