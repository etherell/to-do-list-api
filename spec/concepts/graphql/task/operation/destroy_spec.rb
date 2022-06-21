# frozen_string_literal: true

RSpec.describe Graphql::Task::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, id: task_id) }

  describe '.call' do
    let!(:task) { create(:task) }
    let(:user) { task.project.user }
    let(:task_id) { task.id }
    let(:model_name) { Task.to_s }

    describe 'success' do
      context 'when params task exists' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model]).to eq(task)
          expect(result[:result]).to eq({ result: :completed, errors: [] })
        end

        it 'deletes task' do
          expect { result }.to change(Task, :count).from(1).to(0)
        end
      end
    end

    describe 'failure' do
      context 'when task id is invalid' do
        let(:task_id) { SecureRandom.uuid }

        it_behaves_like 'a not found error'
      end
    end
  end
end
