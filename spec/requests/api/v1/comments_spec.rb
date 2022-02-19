# frozen_string_literal: true

RSpec.describe 'Api::V1::Comments', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/tasks/{task_id}/comments' do
    post 'Creates comment' do
      tags 'Coments'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :task_id, in: :path, type: :string, description: 'Task id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[comment],
        properties: {
          comment: {
            type: :object,
            required: %w[text],
            properties: {
              description: { type: :string, example: FFaker::Lorem.unique.phrase }
            }
          }
        }
      }

      response '201', 'Comment is created' do
        let(:comment_attributes) { attributes_for(:comment).except(:image) }
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:task_id) { task.id }
        let(:params) { { comment: comment_attributes } }
        let(:task) { create(:task) }
        let(:user) { task.project.user }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/comment/create')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:params) { { comment: {} } }
        let(:task_id) { SecureRandom.uuid }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '404', 'Task not found' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:task_id) { SecureRandom.uuid }
        let(:params) { { comment: {} } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '404', 'Task not found' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { project.user }
        let(:task_id) { SecureRandom.uuid }
        let(:project) { create(:project) }
        let(:params) { { comment: {} } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Invalid params' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:task_id) { task.id }
        let(:params) { { comment: {} } }
        let(:task) { create(:task) }
        let(:user) { task.project.user }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end
    end
  end
end
