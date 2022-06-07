# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Index do
  let(:result) { described_class.call(current_user: user, params: params) }
  let(:params) { {} }

  describe '.call' do
    describe 'Success' do
      let(:user) { create(:user) }
      let(:projects_count) { 5 }
      let!(:projects) { create_list(:project, projects_count, user: user) }

      context 'when params are valid' do
        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:semantic_success]).to eq(:ok)
          expect(result[:relation]).to eq(projects)
          expect(result[:serializer]).to be_a(Api::V1::Project::Serializer::Index)
        end
      end

      context 'when search is used and result present' do
        let!(:project) { create(:project, title: title, user: user) }
        let(:params) { { search: title } }
        let(:title) { FFaker::Name.first_name }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:semantic_success]).to eq(:ok)
          expect(result[:relation]).to eq([project])
          expect(result[:serializer]).to be_a(Api::V1::Project::Serializer::Index)
        end
      end

      context 'when search is used and empty result' do
        let(:params) { { search: FFaker::Lorem.phrase } }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:semantic_success]).to eq(:ok)
          expect(result[:relation]).to eq([])
          expect(result[:serializer]).to be_a(Api::V1::Project::Serializer::Index)
        end
      end
    end

    describe 'Failure' do
      context 'when user does not exist' do
        let(:user) { nil }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:forbidden)
        end
      end
    end
  end
end
