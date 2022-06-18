# frozen_string_literal: true

RSpec.describe 'Create user session', type: :request do
  let(:user_password) { 'Pass1234' }
  let(:query) do
    "mutation {
      createSession(input: {
        username: \"#{user.username}\"
        password: \"#{user_password}\"
      }) {
        session {
          access
          refresh
        }
        errors
      }
    }"
  end

  before do
    graphql_post(query: query)
  end

  context 'when input is valid' do
    let!(:user) { create(:user, password: user_password) }

    it 'success' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/session/create/success')
    end
  end

  context 'when password is invalid' do
    let!(:user) { create(:user) }

    it 'failed' do
      expect(response).to be_ok
      expect(response).to match_json_schema('graphql/session/create/unauthorized')
    end
  end
end
