# frozen_string_literal: true

RSpec.describe Graphql::Project::Operation::Index do
  let(:result) { described_class.call(current_user: user) }

  describe '.call' do
    describe 'success' do
      let(:user) { create(:user) }
      let(:projects_count) { 5 }
      let!(:projects) { create_list(:project, projects_count, user: user) }

      context 'when params are valid' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:relation]).to eq(projects)
        end
      end
    end
  end
end
