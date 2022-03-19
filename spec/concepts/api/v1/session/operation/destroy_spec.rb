# frozen_string_literal: true

RSpec.describe Api::V1::Session::Operation::Destroy do
  let(:result) { described_class.call(found_token: refresh_token, payload: payload) }
  let(:payload) { {} }

  describe '.call' do
    context 'when token is valid' do
      let(:refresh_token) { create_token(entity: user, token_type: :refresh) }
      let(:user) { create(:user) }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end
    end

    context 'when token is invalid' do
      let(:refresh_token) { FFaker::Lorem.word }

      it 'operation is failed' do
        expect { result }.to raise_error(JWTSessions::Errors::Unauthorized)
      end
    end
  end
end
