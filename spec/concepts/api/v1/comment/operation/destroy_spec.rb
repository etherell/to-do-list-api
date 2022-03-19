# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { { id: id } }
  let(:user) { comment.task.project.user }

  describe '.call' do
    context 'when params comment exists' do
      let(:comment_attributes) { attributes_for(:comment) }
      let!(:comment) { create(:comment) }
      let(:id) { comment.id }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end

      it 'deletes comment' do
        expect { result }.to change(Comment, :count).from(1).to(0)
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when comment id is invalid' do
        let(:user) { create(:user) }
        let(:id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end
    end
  end
end
