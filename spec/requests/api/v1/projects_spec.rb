# frozen_string_literal: true

RSpec.describe 'Api::V1::Projects', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/projects' do
    post 'Creates Project' do
      tags 'Projects'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[project],
        properties: {
          project: {
            type: :object,
            required: %w[title project_id],
            properties: {
              title: { type: :string, example: FFaker::Lorem.unique.word },
              user_id: { type: :string, example: SecureRandom.uuid }
            }
          }
        }
      }

      response '201', 'Project is created' do
        let(:project_attributes) { attributes_for(:project) }
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:params) { { project: project_attributes } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/project/create')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:params) { { project: {} } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '422', 'Invalid params' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:params) { { project: {} } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end
    end
  end
end
