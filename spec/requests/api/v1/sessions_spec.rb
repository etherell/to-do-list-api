# frozen_string_literal: true

RSpec.describe 'api/v1/sessions', type: :request do
  path '/api/v1/session' do
    post 'Creates Session' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        required: %w[username password],
        properties: {
          username: { type: :string, example: FFaker::InternetSE.login_user_name },
          password: { type: :string, example: FFaker::Internet.password[0...Constants::Shared::PASSWORD_SIZE] }
        }
      }

      after do |example|
        if response.body.present?
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
      end

      response '201', 'Session is created' do
        let(:password) { attributes_for(:user)[:password] }
        let(:user) { create(:user, password: password) }
        let(:credentials) do
          { username: user.username, password: password }
        end

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/session/create')
        end
      end

      response '422', 'Invalid params' do
        let(:credentials) { { username: '', password: '' } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end

      response '401', 'Invalid credentials' do
        let(:credentials) do
          {
            username: FFaker::InternetSE.unique.login_user_name,
            password: FFaker::Internet.password[0...Constants::Shared::PASSWORD_SIZE]
          }
        end

        run_test! do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('api/v1/errors')
        end
      end
    end
  end

  path '/api/v1/session' do
    delete 'Destroys Session' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :'X-Refresh-Token', in: :header, type: :string,
                description: 'Refresh Token'

      response '204', 'Session is destroyed' do
        let(:user) { create(:user) }
        let(:'X-Refresh-Token') { create_token(entity: user, token_type: :refresh) }

        run_test! do
          expect(response).to be_no_content
        end
      end

      response '403', 'Not authorized' do
        let(:'X-Refresh-Token') {}

        run_test! do
          expect(response).to be_forbidden
        end
      end
    end
  end
end
