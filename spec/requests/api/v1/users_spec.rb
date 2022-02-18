# frozen_string_literal: true

RSpec.describe 'Api::V1::Users', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/user' do
    post 'Creates User' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[user],
        properties: {
          user: {
            type: :object,
            required: %w[username password password_confirmation],
            properties: {
              username: { type: :string, example: FFaker::InternetSE.login_user_name },
              password: { type: :string, example: 'Abc43Dea' },
              password_confirmation: { type: :string, example: 'Abc43Dea' }
            }
          }
        }
      }

      response '201', 'User is created' do
        let(:user_attributes) { attributes_for(:user) }
        let(:params) { { user: user_attributes } }

        run_test! do
          expect(response).to be_created
        end
      end

      response '422', 'Invalid params' do
        let(:params) { { user: {} } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end
    end
  end
end
