# frozen_string_literal: true

RSpec.describe 'Create user', type: :request do
  let(:query) do
    "mutation {
      createUser(input: {
        username: \"#{user_username}\"
        password: \"#{user_password}\"
        passwordConfirmation: \"#{user_password}\"
      }) {
        user {
          id
          username
        }
        errors
      }
    }"
  end

  before do
    graphql_post(query: query)
  end

  context 'when input is valid' do
    let(:user_params) { attributes_for(:user) }
    let(:user_username) { user_params[:username] }
    let(:user_password) { user_params[:password] }

    it 'success' do
      expect(response).to be_ok
      expect(response).to match_schema(UserCreateSchema::Success)
    end
  end

  context 'when params is emtpy' do
    let(:user_username) { nil }
    let(:user_password) { nil }

    it 'failed' do
      expect(response).to be_ok
      expect(response).to match_schema(UserCreateSchema::Error)
    end
  end
end
