# frozen_string_literal: true

RSpec.describe 'Projects list', type: :request do
  let(:query) do
    "query {
      projects {
        title,
        id
      }
    }"
  end

  before do
    create_list(:project, 3, user: user)
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
