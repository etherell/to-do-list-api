# frozen_string_literal: true

RSpec.describe Api::V1::User::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:user_attributes) { attributes_for(:user) }
      let(:params) { { user: user_attributes } }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
      end

      it 'creates new user' do
        expect { result }.to change(User, :count).by(1)
      end
    end

    context 'when params are invalid' do
      context 'when params are empty' do
        let(:params) { { user: {} } }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result['contract.default'].errors).not_to be_empty
        end
      end
    end
  end
end
