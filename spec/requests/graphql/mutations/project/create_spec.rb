# frozen_string_literal: true

RSpec.describe 'Create project', type: :request do
  let(:user) { create(:user) }
  let(:project_attributes) { attributes_for(:project) }
  let(:project_title) { project_attributes[:title] }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:query) do
    "mutation {
      createProject(input: {
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
      expect(response).to match_json_schema('graphql/project/create/success')
    end
  end

  context 'when params is emtpy' do
    let(:project_title) { nil }

    it 'returns unprocessable error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/create/unprocessable')
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/create/unauthorized')
    end
  end
end
