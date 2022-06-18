# frozen_string_literal: true

RSpec.describe Graphql::Project::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:user) { create(:user) }

  describe '.call' do
    describe 'success' do
      context 'when params are valid' do
        let(:project_attributes) { attributes_for(:project) }
        let(:params) { project_attributes }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model]).to be_a(Project)
          expect(result[:result]).to eq({ project: result[:model], errors: [] })
        end

        it 'creates new project' do
          expect { result }.to change(Project, :count).from(0).to(1)
        end
      end
    end

    describe 'failure' do
      context 'when params are empty' do
        let(:params) {}
        let(:error_attributes) { { options: { status: :unprocessable_entity, code: 422 } } }

        it 'raises unprocessable error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end
    end
  end
end
