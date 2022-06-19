# frozen_string_literal: true

RSpec.describe 'Destroy task', type: :request do
  let!(:task) { create(:task) }
  let(:user) { task.project.user }
  let(:task_id) { task.id }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      destroyTask(input: {
        id: \"#{task_id}\"
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
      expect(response).to match_schema(TaskDestroySchema::Success)
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskDestroySchema::Error)
    end
  end

  context 'when id is invalid' do
    let(:task_id) { SecureRandom.uuid }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskDestroySchema::Error)
    end
  end
end
