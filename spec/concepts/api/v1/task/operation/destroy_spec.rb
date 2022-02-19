# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { { project_id: project_id, id: id } }
  let(:user) { create(:user) }

  describe '.call' do
    context 'when params task exists' do
      let(:task_attributes) { attributes_for(:task) }
      let(:project) { create(:project, user: user) }
      let!(:task) { create(:task, project: project) }
      let(:id) { task.id }
      let(:project_id) { project.id }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end

      it 'deletes task' do
        expect { result }.to change(Task, :count).from(1).to(0)
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:id) { SecureRandom.uuid }
        let(:project_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when project id is invalid' do
        let(:id) { SecureRandom.uuid }
        let(:project_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when task id is invalid' do
        let(:project) { create(:project, user: user) }
        let(:project_id) { project.id }
        let(:id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end
    end
  end
end
