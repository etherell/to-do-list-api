# frozen_string_literal: true

RSpec.describe Graphql::Comment::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { comment_attributes.merge(task_id: task_id) }

  describe '.call' do
    let(:comment_attributes) { attributes_for(:comment, :with_base_64_image) }
    let(:user) { task.project.user }
    let(:task) { create(:task) }
    let(:task_id) { task.id }

    describe 'success' do
      context 'when params are valid' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:task]).to eq(task)
          expect(result[:model]).to be_a(Comment)
          expect(result[:result]).to eq({ comment: result[:model], errors: [] })
        end

        it 'creates new comment' do
          expect { result }.to change(Comment, :count).from(0).to(1)
        end
      end
    end

    describe 'failure' do
      context 'when invalid task id' do
        let(:task_id) { SecureRandom.uuid }
        let(:model_name) { Task.to_s }

        it_behaves_like 'a not found error'
      end

      context 'when comment params are empty' do
        let(:comment_attributes) { {} }

        it_behaves_like 'an unprocessable error'
      end
    end
  end
end
