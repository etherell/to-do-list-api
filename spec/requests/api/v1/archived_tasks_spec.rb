# frozen_string_literal: true

RSpec.describe 'Api::V1::ArchivedTasks', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/archived_tasks' do
    get 'Archived tasks list' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'Tasks list are returned' do
        let(:Authorization) { create_token(entity: user, token_type: :access) }
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let!(:task) { create_list(:task, 3, project: project, deadline: 31.days.since) }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/archived_task/index')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
