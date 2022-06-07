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
            required: %w[title],
            properties: {
              title: { type: :string, example: FFaker::Lorem.unique.phrase }
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

  path '/api/v1/projects/{id}' do
    patch 'Updates Project' do
      tags 'Projects'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string, description: 'Project id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[project],
        properties: {
          project: {
            type: :object,
            required: %w[title],
            properties: {
              title: { type: :string, example: FFaker::Lorem.unique.phrase }
            }
          }
        }
      }

      response '200', 'Project updated' do
        let(:project_attributes) { attributes_for(:project) }
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:id) { project.id }
        let(:params) { { project: project_attributes } }
        let!(:in_time_tasks) { create_list(:task, 3, deadline: Time.zone.now - 1.day, project: project) }
        let!(:overdue_tasks) { create_list(:task, 1, deadline: Time.zone.now + 1.day, project: project) }

        before do
          project.tasks.each { |task| task.update(is_done: true) }
        end

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/project/update')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { SecureRandom.uuid }
        let(:params) { { project: {} } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '422', 'Invalid params' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:params) { { project: invalid_params } }
        let(:project) { create(:project, user: user) }
        let(:id) { project.id }
        let(:invalid_params)  { { title: '' } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/errors')
        end
      end

      response '404', 'Project not found' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:id) { SecureRandom.uuid }
        let(:params) { { project: {} } }

        run_test! do
          expect(response).to be_not_found
        end
      end
    end
  end

  path '/api/v1/projects/{id}' do
    delete 'Deletes Project' do
      tags 'Projects'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string, description: 'Project id'

      response '204', 'Project deleted' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:id) { project.id }

        run_test! do
          expect(response).to be_no_content
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { SecureRandom.uuid }
        let(:params) { { project: {} } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '404', 'Project not found' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:id) { SecureRandom.uuid }

        run_test! do
          expect(response).to be_not_found
        end
      end
    end
  end
end
