# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Service::Session do
  describe '.create' do
    let(:user) { create(:user) }
    let(:result) { described_class.create(user_id: user.id) }

    it 'returns tokens' do
      expect(result).to be_a(Hash)
      expect(result).to include(:access, :refresh, :csrf, :access_expires_at, :refresh_expires_at)
    end
  end

  describe '.destroy' do
    let(:result) { described_class.destroy(refresh_token: refresh_token) }

    context 'with valid token' do
      let(:user) { create(:user) }
      let(:refresh_token) { create_token(entity: user, token_type: :refresh) }
      let(:sessions_count) { 1 }

      it 'returns truthy result' do
        expect(result).to be_truthy
        expect(result).to eq(sessions_count)
      end
    end

    context 'with invalid token' do
      let(:refresh_token) { FFaker::Lorem.word }

      it 'raises unauthorized error' do
        expect { result }.to raise_error(JWTSessions::Errors::Unauthorized)
      end
    end
  end

  describe '.destroy_all' do
    let(:result) { described_class.destroy_all(namespace: namespace) }

    context 'when at least 1 session with given namespace exists' do
      let(:user) { create(:user) }
      let(:namespace_prefix) { Constants::TokenNamespace::SESSION }
      let(:namespace) { "#{Constants::TokenNamespace::SESSION}-#{user.id}" }
      let(:sessions_count) { 1 }

      before { described_class.create(user_id: user.id, namespace_prefix: namespace_prefix) }

      it 'returns quantity of sessions' do
        expect(result).to eq(sessions_count)
      end
    end

    context 'when specific count of sessions with one namespace exist' do
      let(:user) { create(:user) }
      let(:namespace_prefix) { Constants::TokenNamespace::SESSION }
      let(:namespace) { "#{Constants::TokenNamespace::SESSION}-#{user.id}" }
      let(:count_of_sessions) { 3 }

      before do
        count_of_sessions.times do
          described_class.create(user_id: user.id, namespace_prefix: namespace_prefix)
        end
      end

      it 'returns quantity of the sessions' do
        expect(result).to eq(count_of_sessions)
      end
    end

    context 'when no active session with given namespace' do
      let(:user) { create(:user) }
      let(:namespace) { "#{FFaker::Lorem.word}-#{user.id}" }

      before { described_class.create(user_id: user.id) }

      it 'returns no sessions' do
        expect(result).to be_zero
      end
    end
  end

  describe '.refresh' do
    let(:result) { described_class.refresh(refresh_token: refresh_token, payload: {}) }

    context 'when token is valid' do
      let(:user) { create(:user) }
      let(:refresh_token) { create_token(entity: user, token_type: :refresh) }

      it 'returns new tokens' do
        expect(result).to be_a(Hash)
        expect(result).to include(:access, :refresh, :csrf, :access_expires_at, :refresh_expires_at)
      end
    end

    context 'with invalid token' do
      let(:refresh_token) { FFaker::Lorem.word }

      it 'raises unauthorized error' do
        expect { result }.to raise_error(JWTSessions::Errors::Unauthorized)
      end
    end
  end
end
