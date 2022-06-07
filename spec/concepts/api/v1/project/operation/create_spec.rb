# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Create do
  let(:result) { described_class.call(current_user: user, params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:project_attributes) { attributes_for(:project) }
      let(:params) { { project: project_attributes } }
      let(:user) { create(:user) }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:serializer]).to be_a(Api::V1::Project::Serializer::Create)
        expect(result[:semantic_success]).to eq(:created)
      end

      it 'creates new project' do
        expect { result }.to change(Project, :count).from(0).to(1)
      end
    end

    context 'when current user does not exist' do
      context 'when params are empty' do
        let(:user) { nil }
        let(:params) { { project: {} } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end
    end

    context 'when params are invalid' do
      context 'when params are empty' do
        let(:user) { create(:user) }
        let(:params) { { project: {} } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end
    end
  end
end
