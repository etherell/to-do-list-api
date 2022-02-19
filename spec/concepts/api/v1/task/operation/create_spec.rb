# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:task_attributes) { attributes_for(:task) }
      let(:params) { { task: task_attributes, project_id: project.id } }
      let(:user) { create(:user) }
      let(:project) { create(:project, user: user) }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:serializer]).to be_a(Api::V1::Task::Serializer::Show)
        expect(result[:semantic_success]).to eq(:created)
      end

      it 'creates new task' do
        expect { result }.to change(Task, :count).from(0).to(1)
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:params) { { task: {} } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when invalid project id' do
        let(:user) { create(:user) }
        let(:invalid_project_id) { SecureRandom.uuid }
        let(:params) { { task: {}, project_id: invalid_project_id } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when task params are empty' do
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:params) { { task: {}, project_id: project.id } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end
    end
  end
end
