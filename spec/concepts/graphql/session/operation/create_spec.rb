# frozen_string_literal: true

RSpec.describe Graphql::Session::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    describe 'success' do
      context 'when params are valid' do
        let(:password) { attributes_for(:user)[:password] }
        let(:user) { create(:user, password: password) }
        let(:params) { { username: user.username, password: password } }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model]).to eq(user)
          expect(result[:session]).to include(:access, :refresh, :csrf, :access_expires_at, :refresh_expires_at)
          expect(result[:result]).to eq({ session: result[:session], errors: [] })
        end
      end
    end

    describe 'failure' do
      context 'when params are empty' do
        let(:params) { {} }
        let(:error_attributes) { { options: { status: :unprocessable_entity, code: 422 } } }

        it 'raises unprocessable error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end

      context 'when user with user name does not exist' do
        let(:params) { attributes_for(:user) }
        let(:error_attributes) do
          { message: I18n.t('errors.not_found', model_name: 'User'), options: { status: :not_found, code: 404 } }
        end

        it 'raises not found error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end

      context 'when wrong password' do
        let(:wrong_password) { 'Wrong123' }
        let(:user) { create(:user) }
        let(:params) { { username: user.username, password: wrong_password } }
        let(:error_attributes) do
          { message: I18n.t('errors.session.wrong_credentials'), options: { status: :unauthorized, code: 401 } }
        end

        it 'raises not found error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end
    end
  end
end
