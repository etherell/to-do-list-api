# frozen_string_literal: true

class Comment < ApplicationRecord
  include PgSearch::Model

  multisearchable against: :text

  belongs_to :task

  mount_uploader :image, ImageUploader
end
