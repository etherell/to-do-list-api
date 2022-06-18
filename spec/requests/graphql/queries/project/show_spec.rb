# frozen_string_literal: true

RSpec.describe 'Projects list', type: :request do
  let!(:project) { create(:project, user: user) }
  let(:project_id) { project.id }
  let(:user) { create(:user) }
  let(:query) do
    "query {
      project(id: \"#{project_id}\") {
        title,
        id
      }
    }"
  end

  before do
    graphql_post(query: query, headers: { 'Authorization': token })
  end

  context 'when params is valid' do
    let(:token) { create_token(entity: user, token_type: :access) }

    it 'success' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/show/success')
    end
  end

  context 'when project id is invalid' do
    let(:token) { create_token(entity: user, token_type: :access) }
    let(:project_id) { SecureRandom.uuid }

    it 'returns not found error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/show/not_found')
    end
  end

  context 'when token is invalid' do
    let(:token) {}

    it 'returns unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/show/unauthorized')
    end
  end
end
