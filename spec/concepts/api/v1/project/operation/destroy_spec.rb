# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Destroy do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { { id: project_id } }
  let(:user) { create(:user) }

  describe '.call' do
    context 'when params project exists' do
      let(:project_attributes) { attributes_for(:project) }
      let!(:project) { create(:project, user: user) }
      let(:project_id) { project.id }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end

      it 'deletes project' do
        expect { result }.to change(Project, :count).from(1).to(0)
      end
    end

    context 'when params are invalid' do
      context 'when user does not exist' do
        let(:user) { nil }
        let(:project_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end

      context 'when project id is invalid' do
        let(:project_id) { SecureRandom.uuid }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end
    end
  end
end
