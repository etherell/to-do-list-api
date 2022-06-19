# frozen_string_literal: true

RSpec.describe Graphql::Project::Operation::Show do
  let(:result) { described_class.call(current_user: user, id: project_id) }
  let(:user) { create(:user) }

  describe '.call' do
    describe 'success' do
      context 'when params project exists' do
        let(:project_attributes) { attributes_for(:project) }
        let!(:project) { create(:project, user: user) }
        let(:project_id) { project.id }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model_name]).to eq('Project')
          expect(result[:model]).to eq(project)
        end
      end
    end

    describe 'failure' do
      context 'when wrong project id' do
        let(:project_id) { SecureRandom.uuid }
        let(:model_name) { Project.to_s }

        it_behaves_like 'a not found error'
      end
    end
  end
end
