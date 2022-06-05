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

  describe 'full text search by text' do
    let(:multisearch) { PgSearch.multisearch(text) }
    let(:text) { FFaker::Lorem.word }

    context 'with search by correct phrase' do
      let!(:comment) { create(:comment, text: text) }

      it 'returns correct comment' do
        expect(multisearch.last.searchable).to eq(comment)
      end
    end

    context 'with search by random phrase' do
      let!(:comment) { create(:comment, text: FFaker::Name.first_name) }

      it 'returns nothing' do
        expect(multisearch).to eq([])
      end
    end
  end
end
