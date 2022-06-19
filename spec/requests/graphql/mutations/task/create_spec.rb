# frozen_string_literal: true

RSpec.describe 'Create task', type: :request do
  let(:project) { create(:project) }
  let(:user) { project.user }
  let(:task_attributes) { attributes_for(:task) }
  let(:task_description) { task_attributes[:description] }
  let(:task_deadline) { task_attributes[:deadline].to_s }
  let(:project_id) { project.id }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      createTask(input: {
        description: \"#{task_description}\",
        deadline: \"#{task_deadline}\",
        projectId: \"#{project_id}\"
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
      expect(response).to match_schema(TaskCreateSchema::Success)
    end
  end

  context 'when params is emtpy' do
    let(:task_description) { nil }

    it 'returns unprocessable error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskCreateSchema::Error)
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(TaskCreateSchema::Error)
    end
  end
end
