# frozen_string_literal: true

RSpec.describe Graphql::Project::Operation::Update do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:project) { create(:project, user: user) }
  let(:user) { create(:user) }
  let(:params) { project_attributes.merge(id: project_id) }
  let(:project_id) { project.id }
  let(:project_attributes) { attributes_for(:project) }

  describe '.call' do
    describe 'success' do
      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:model_name]).to eq('Project')
        expect(result[:model]).to eq(project)
        expect(result[:result]).to eq({ project: result[:model], errors: [] })
      end

      it 'updates project' do
        result
        expect(project.reload.title).to eq(project_attributes[:title])
      end
    end

    describe 'failure' do
      context 'when title is invalid' do
        let(:project_attributes) { { title: '' } }

        it_behaves_like 'an unprocessable error'
      end

      context 'when wrong project id' do
        let(:project_id) { SecureRandom.uuid }
        let(:model_name) { Project.to_s }

        it_behaves_like 'a not found error'
      end
    end
  end
end
