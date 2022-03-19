# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { { comment: comment_attributes, task_id: task_id } }

  describe '.call' do
    context 'when params are valid' do
      let(:comment_attributes) { attributes_for(:comment) }
      let(:user) { task.project.user }
      let(:task) { create(:task) }
      let(:task_id) { task.id }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:serializer]).to be_a(Api::V1::Comment::Serializer::Show)
        expect(result[:semantic_success]).to eq(:created)
      end

      it 'creates new comment' do
        expect { result }.to change(Comment, :count).from(0).to(1)
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:comment_attributes) { {} }
        let(:params) { { comment: {} } }
        let(:task_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when invalid task id' do
        let(:comment_attributes) { {} }
        let(:user) { create(:user) }
        let(:task_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when comment params are empty' do
        let(:comment_attributes) { {} }
        let(:user) { task.project.user }
        let(:task) { create(:task) }
        let(:task_id) { task.id }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end
    end
  end
end
