# frozen_string_literal: true

RSpec.describe Graphql::Task::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }

  describe '.call' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:project_id) { project.id }
    let(:task_attributes) { attributes_for(:task) }
    let(:params) { task_attributes.merge(project_id: project_id) }

    describe 'success' do
      context 'when params are valid' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:project]).to eq(project)
          expect(result[:model]).to be_a(Task)
          expect(result[:result]).to eq({ task: result[:model], errors: [] })
        end

        it 'creates new task' do
          expect { result }.to change(Task, :count).from(0).to(1)
        end
      end
    end

    describe 'failure' do
      context 'when invalid project id' do
        let(:project_id) { SecureRandom.uuid }
        let(:model_name) { Project.to_s }

        it_behaves_like 'a not found error'
      end

      context 'when task params are empty' do
        let(:task_attributes) { {} }

        it_behaves_like 'an unprocessable error'
      end
    end
  end
end
