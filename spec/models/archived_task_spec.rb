# frozen_string_literal: true

RSpec.describe ArchivedTask, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
  end
end
