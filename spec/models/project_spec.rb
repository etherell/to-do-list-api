# frozen_string_literal: true

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'full text search by title' do
    let(:search_by_title) { described_class.search_by_title(title) }
    let(:title) { FFaker::Lorem.word }

    context 'with search by correct phrase' do
      let!(:project) { create(:project, title: title) }

      it 'returns correct project' do
        expect(search_by_title).to eq([project])
      end
    end

    context 'with search by random phrase' do
      let!(:project) { create(:project, title: FFaker::Name.first_name) }

      it 'returns nothing' do
        expect(search_by_title).to eq([])
      end
    end
  end
end
