# frozen_string_literal: true

RSpec.describe 'Destroy Comment', type: :request do
  let!(:comment) { create(:comment) }
  let(:user) { comment.task.project.user }
  let(:comment_id) { comment.id }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      destroyComment(input: {
        id: \"#{comment_id}\"
      }) {
        result
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
      expect(response).to match_schema(CommentDestroySchema::Success)
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(CommentDestroySchema::Error)
    end
  end

  context 'when id is invalid' do
    let(:comment_id) { SecureRandom.uuid }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(CommentDestroySchema::Error)
    end
  end
end
