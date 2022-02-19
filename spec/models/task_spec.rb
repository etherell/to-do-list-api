# frozen_string_literal: true

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:description).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:project_id) }
  end
end
