# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_secure_password }
    it { is_expected.to have_db_column(:username).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:username).unique(true) }
  end
end
