# frozen_string_literal: true

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end
end
