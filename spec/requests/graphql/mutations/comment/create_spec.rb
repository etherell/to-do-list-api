# frozen_string_literal: true

RSpec.describe 'Create comment', type: :request do
  let(:task) { create(:task) }
  let(:user) { task.project.user }
  let(:comment_attributes) { attributes_for(:comment, :with_base_64_image) }
  let(:comment_text) { comment_attributes[:text] }
  let(:comment_image) { comment_attributes[:image] }
  let(:task_id) { task.id }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      createComment(input: {
        text: \"#{comment_text}\",
        image: \"#{comment_image}\",
        taskId: \"#{task_id}\"
      }) {
        comment {
          id,
          text,
          image
        }
        errors
      }
    }"
  end

  before do
    graphql_post(query: query, headers: { 'Authorization': token })
  end

  context 'when input is valid' do
    it 'returns success response' do
      expect(response).to be_ok
      expect(response).to match_schema(CommentCreateSchema::Success)
    end
  end

  context 'when params is emtpy' do
    let(:comment_text) { nil }

    it 'returns unprocessable error' do
      expect(response).to be_ok
      expect(response).to match_schema(CommentCreateSchema::Error)
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(CommentCreateSchema::Error)
    end
  end
end
