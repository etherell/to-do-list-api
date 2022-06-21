# frozen_string_literal: true

RSpec.describe 'Projects list', type: :request do
  let(:project) { create(:project, user: user) }
  let(:tasks) { create_list(:task, 3, project: project) }
  let(:query) do
    "query {
      projects {
        title,
        id,
        tasks {
          id,
          description,
          isDone,
          deadline,
          position,
          comments {
            id,
            text,
            image,
          }
        }
      }
    }"
  end

  before do
    tasks.each { |task| create(:comment, task: task) }
    graphql_post(query: query, headers: { 'Authorization': token })
  end

  context 'when token is valid' do
    let(:token) { create_token(entity: user, token_type: :access) }
    let(:user) { create(:user) }

    it 'success' do
      expect(response).to be_ok
      expect(response).to match_schema(ProjectIndexchema::Success)
    end
  end

  context 'when token is invalid' do
    let(:token) {}
    let(:user) { create(:user) }

    it 'failed' do
      expect(response).to be_ok
      expect(response).to match_schema(ProjectIndexchema::Error)
    end
  end
end
