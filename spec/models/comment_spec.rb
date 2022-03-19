# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:text).of_type(:string) }
    it { is_expected.to have_db_column(:image).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:task_id) }
  end
end
