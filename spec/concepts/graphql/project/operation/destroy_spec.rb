# frozen_string_literal: true

RSpec.describe Graphql::Project::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, id: project_id) }
  let(:user) { create(:user) }

  describe '.call' do
    describe 'success' do
      context 'when params project exists' do
        let!(:project) { create(:project, user: user) }
        let(:project_id) { project.id }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:result]).to eq({ result: :completed, errors: [] })
        end

        it 'deletes project' do
          expect { result }.to change(Project, :count).from(1).to(0)
        end
      end
    end

    describe 'failure' do
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
