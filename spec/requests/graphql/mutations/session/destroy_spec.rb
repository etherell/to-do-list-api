# frozen_string_literal: true

RSpec.describe 'Create user session', type: :request do
  let(:query) do
    "mutation {
      destroySession(input: {}) {
        result
        errors
      }
    }"
  end
  let(:tokens) { create_token(entity: user) }
  let(:user) { create(:user) }

  context 'when tokens is valid' do
    before do
      graphql_post(query: query, headers: { 'Authorization': tokens[:access], 'X-Refresh-Token': tokens[:refresh] })
    end

    it 'success' do
      expect(response).to be_ok
      expect(response).to match_schema(SessionDestroySchema::Success)
    end
  end

  context 'without refresh token' do
    before do
      graphql_post(query: query, headers: { 'Authorization': tokens[:access] })
    end

    it 'returns unathorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(SessionDestroySchema::Error)
    end
  end

  context 'without access token' do
    before do
      graphql_post(query: query)
    end

    it 'returns unathorized error' do
      expect(response).to be_ok
      expect(response).to match_schema(SessionDestroySchema::Error)
    end
  end
end
