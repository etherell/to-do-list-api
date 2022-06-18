# frozen_string_literal: true

RSpec.describe 'Destroy project', type: :request do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:token) { create_token(entity: user, token_type: :access) }
  let(:project_id) { project.id }
  let(:query) do
    "mutation {
      destroyProject(input: {
        id: \"#{project_id}\"
      }) {
        result
        errors
      }
    }
    "
  end

  before do
    graphql_post(query: query, headers: { 'Authorization': token })
  end

  context 'when input is valid' do
    it 'returns success response' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/destroy/success')
    end
  end

  context 'when wrong id' do
    let(:project_id) { SecureRandom.uuid }

    it 'returns not found error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/destroy/not_found')
    end
  end

  context 'when token is emtpy' do
    let(:token) { nil }

    it 'return unauthorized error' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/project/destroy/unauthorized')
    end
  end
end
