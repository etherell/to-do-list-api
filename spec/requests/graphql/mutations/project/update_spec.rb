# frozen_string_literal: true

RSpec.describe 'Update project', type: :request do
  let(:user) { create(:user) }
  let(:project_attributes) { attributes_for(:project) }
  let(:project_title) { project_attributes[:title] }
  let(:token) { create_token(entity: user, token_type: :access) }
  let!(:project) { create(:project, user: user) }
  let(:project_id) { project.id }
  let(:query) do
    "mutation {
      updateProject(input: {
        id: \"#{project_id}\",
        title: \"#{project_title}\"
      }) {
        project {
          id,
          title,
          user {
            id
            username
          }
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
      expect(response).to match_json_schema('graphql/project/update/success')
    end
  end

  context 'when params is emtpy' do
    let(:project_title) { nil }

    it 'returns unprocessable error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/update/unprocessable')
    end
  end

  context 'when wrong project id' do
    let(:project_id) { SecureRandom.uuid }

    it 'returns not found error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/update/not_found')
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/update/unauthorized')
    end
  end
end
