# frozen_string_literal: true

RSpec.describe 'Api::V1::Tasks', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/projects/{project_id}/tasks' do
    post 'Creates task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :project_id, in: :path, type: :string, description: 'Project id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[task],
        properties: {
          task: {
            type: :object,
            required: %w[description],
            properties: {
              description: { type: :string, example: FFaker::Lorem.unique.phrase }
            }
          }
        }
      }

      response '201', 'Task is created' do
        let(:task_attributes) { attributes_for(:task) }
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:project_id) { project.id }
        let(:params) { { task: task_attributes } }
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/task/create')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:params) { { task: {} } }
        let(:project_id) { SecureRandom.uuid }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '404', 'Project not found' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:project_id) { SecureRandom.uuid }
        let(:params) { { task: {} } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Invalid params' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:project_id) { project.id }
        let(:params) { { task: {} } }
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end
    end
  end
end
