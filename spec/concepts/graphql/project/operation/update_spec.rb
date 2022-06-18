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
        let(:error_attributes) { { options: { status: :unprocessable_entity, code: 422 } } }

        it 'raises unprocessable error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end

      context 'when wrong project id' do
        let(:project_id) { SecureRandom.uuid }
        let(:error_attributes) do
          { message: I18n.t('errors.not_found', model_name: 'Project'), options: { status: :not_found, code: 404 } }
        end

        it 'raises not found error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end
    end
  end
end
