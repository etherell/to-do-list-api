# frozen_string_literal: true

RSpec.describe 'Update task', type: :request do
  let(:task) { create(:task) }
  let(:user) { task.project.user }
  let(:task_attributes) { attributes_for(:task) }
  let(:task_id) { task.id }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      updateTask(input: {
        description: \"#{task_attributes[:description]}\",
        deadline: \"#{task_attributes[:deadline]&.to_s}\",
        position: #{task_attributes[:position]},
        isDone: #{task_attributes[:is_done]},
        id: \"#{task_id}\"
      }) {
        task {
          id,
          deadline,
          description,
          position,
          isDone
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
      expect(response).to match_schema(TaskUpdateSchema::Success)
    end
  end

  context 'when params is emtpy' do
    let(:task_attributes) { attributes_for(:task).merge(description: '') }

    it 'returns unprocessable error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskUpdateSchema::Error)
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskUpdateSchema::Error)
    end
  end

  context 'when id is invalid' do
    let(:task_id) { SecureRandom.uuid }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskUpdateSchema::Error)
    end
  end
end
