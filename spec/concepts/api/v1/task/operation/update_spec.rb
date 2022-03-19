# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Update do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { { task: task_attributes, id: task_id } }

  describe '.call' do
    context 'when params are valid' do
      let(:task_attributes) { attributes_for(:task) }
      let(:user) { task.project.user }
      let(:task) { create(:task) }
      let(:task_id) { task.id }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:serializer]).to be_a(Api::V1::Task::Serializer::Show)
        expect(result[:semantic_success]).to eq(:ok)
      end

      it 'creates new task' do
        result
        expect(task.reload.description).to eq(task_attributes[:description])
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:task_attributes) { {} }
        let(:task_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when invalid task id' do
        let(:user) { create(:user) }
        let(:task_attributes) { {} }
        let(:task_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when task params are empty' do
        let(:user) { task.project.user }
        let(:task) { create(:task) }
        let(:task_id) { task.id }
        let(:task_attributes) { {} }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end
    end
  end
end
