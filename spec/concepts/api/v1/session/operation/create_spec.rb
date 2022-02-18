# frozen_string_literal: true

RSpec.describe Api::V1::Session::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:password) { attributes_for(:user)[:password] }
      let(:user) { create(:user, password: password) }
      let(:params) { { username: user.username, password: password } }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:model]).to eq(user)
        expect(result[:model]).not_to be nil
        expect(result[:session_tokens]).to include(:access, :refresh, :csrf, :access_expires_at, :refresh_expires_at)
        expect(result[:serializer]).to be_a(Api::V1::User::Serializer::Create)
        expect(result[:semantic_success]).to eq(:created)
      end
    end

    context 'when params are invalid' do
      context 'when params are empty' do
        let(:params) { {} }

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:'result.contract.default'].errors).not_to be_empty
          expect(result[:session_tokens]).to be nil
          expect(result[:model]).to be nil
          expect(result[:serializer]).to be nil
        end
      end

      context 'when passed wrong username' do
        let(:params) do
          {
            username: FFaker::InternetSE.unique.login_user_name,
            password: 'Pass1234'
          }
        end

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:model]).to be nil
          expect(result[:'result.contract.default'].errors.messages)
            .to eq(base: [I18n.t('errors.session.wrong_credentials')])
          expect(result[:semantic_failure]).to eq(:unauthorized)
          expect(result[:session_tokens]).to be nil
          expect(result[:serializer]).to be nil
        end
      end

      context 'when passed wrong password' do
        let(:user) { create(:user) }
        let(:invalid_password) { 'Invalid1' }
        let(:params) do
          {
            username: user.username,
            password: invalid_password
          }
        end

        it 'operatiom is failed' do
          expect(result).to be_failure
          expect(result[:model]).to eq(user)
          expect(result[:'result.contract.default'].errors.messages)
            .to eq(base: [I18n.t('errors.session.wrong_credentials')])
          expect(result[:semantic_failure]).to eq(:unauthorized)
          expect(result[:session_tokens]).to be nil
          expect(result[:serializer]).to be nil
        end
      end
    end
  end
end
