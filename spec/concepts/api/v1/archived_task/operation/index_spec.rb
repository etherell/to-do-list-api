# frozen_string_literal: true

RSpec.describe Api::V1::ArchivedTask::Operation::Index do
  let(:result) { described_class.call(current_user: user) }

  describe '.call' do
    context 'when params are valid' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user: user) }
      let!(:task) { create(:task, project: project, deadline: 31.days.since) }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
        expect(result[:serializer]).to be_a(Api::V1::ArchivedTask::Serializer::Index)
      end
    end

    context 'when params are invalid' do
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
