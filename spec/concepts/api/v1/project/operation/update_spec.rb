# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Update do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:project) { create(:project, user: user) }
  let(:user) { create(:user) }

  describe '.call' do
    context 'when params are valid' do
      let(:project_attributes) { attributes_for(:project) }
      let(:params) { { project: project_attributes, id: project.id } }
      let!(:in_time_tasks) { create_list(:task, 3, deadline: Time.zone.now - 1.day, project: project) }
      let!(:overdue_tasks) { create_list(:task, 1, deadline: Time.zone.now + 1.day, project: project) }
      let(:expected_serializer_options) do
        { params: { in_time_percentage: 75, overdue_percantage: 25 } }
      end

      before do
        project.tasks.each { |task| task.update(is_done: true) }
      end

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:serializer]).to be_a(Api::V1::Project::Serializer::Update)
        expect(result[:serializer_options]).to eq(expected_serializer_options)
        expect(result[:semantic_success]).to eq(:ok)
      end

      it 'creates new project' do
        result
        expect(project.reload.title).to eq(project_attributes[:title])
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:params) { { project: {} } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when title is invalid' do
        let(:params) { { project: project_attributes, id: project.id } }
        let(:project_attributes) { { title: '' } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end

      context 'when project id is invalid' do
        let(:params) { { project: project_attributes, id: invalid_id } }
        let(:project_attributes) { attributes_for(:project) }
        let(:invalid_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end
    end
  end
end
