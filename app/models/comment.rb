# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task

  mount_uploader :image, ImageUploader
end
