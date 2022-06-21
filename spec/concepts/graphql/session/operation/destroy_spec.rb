# frozen_string_literal: true

RSpec.describe Graphql::Session::Operation::Destroy do
  let(:result) { described_class.call(refresh_token: refresh_token) }
  let(:payload) { {} }

  describe '.call' do
    context 'when token is valid' do
      let(:refresh_token) { create_token(entity: user, token_type: :refresh) }
      let(:user) { create(:user) }
      let(:success_result) { { result: :completed, errors: [] } }

      it 'operation is successed' do
        expect(result).to be_success
        expect(result[:result]).to eq(success_result)
      end
    end

    context 'when token is invalid or empty' do
      let(:refresh_token) { nil }
      let(:error_message) { I18n.t('errors.not_authorized') }
      let(:error_attributes) { { message: error_message, options: { status: :unauthorized, code: 401 } } }

      it 'raises unauthorized error' do
        expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                          .and(having_attributes(error_attributes)))
      end
    end
  end
end
