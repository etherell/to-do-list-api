# frozen_string_literal: true

RSpec.describe Graphql::Comment::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, id: id) }
  let(:params) { { id: id } }
  let(:user) { comment.task.project.user }

  describe '.call' do
    let(:comment_attributes) { attributes_for(:comment) }
    let!(:comment) { create(:comment) }
    let(:id) { comment.id }

    describe 'success' do
      context 'when params comment exists' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model_name]).to eq(Comment.to_s)
          expect(result[:model]).to eq(comment)
          expect(result[:result]).to eq({ result: :completed, errors: [] })
        end

        it 'deletes comment' do
          expect { result }.to change(Comment, :count).from(1).to(0)
        end
      end
    end

    describe 'failure' do
      context 'when comment id is invalid' do
        let(:id) { SecureRandom.uuid }
        let(:model_name) { Comment.to_s }

        it_behaves_like 'a not found error'
      end
    end
  end
end
