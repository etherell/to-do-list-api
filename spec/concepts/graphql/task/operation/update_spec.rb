# frozen_string_literal: true

RSpec.describe Graphql::Task::Operation::Update do
  let(:result) { described_class.call(current_user: user, params: params) }

  describe '.call' do
    let(:user) { task.project.user }
    let(:task) { create(:task) }
    let(:task_attributes) { attributes_for(:task) }
    let(:task_id) { task.id }
    let(:params) { task_attributes.merge(id: task_id) }
    let(:model_name) { Task.to_s }

    describe 'success' do
      context 'when params are valid' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model]).to eq(task)
          expect(result[:result]).to eq({ task: task, errors: [] })
        end

        it 'changes task description' do
          expect { result }.to change { task.reload.description }.to(task_attributes[:description])
        end
      end
    end

    describe 'failure' do
      context 'when invalid task id' do
        let(:task_id) { SecureRandom.uuid }

        it_behaves_like 'a not found error'
      end

      context 'when task params are empty' do
        let(:task_attributes) { {} }

        it_behaves_like 'an unprocessable error'
      end
    end
  end
end
