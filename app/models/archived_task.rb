# frozen_string_literal: true

class ArchivedTask < ApplicationRecord
  belongs_to :project
end
