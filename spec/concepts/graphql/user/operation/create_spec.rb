# frozen_string_literal: true

RSpec.describe Graphql::User::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    describe 'success' do
      context 'when params are valid' do
        let(:params) { attributes_for(:user) }
        let(:expected_result) { { user: result[:model], errors: [] } }

        it 'operation is successed' do
          expect(result).to be_success
          expect(result[:model]).to be_a(User)
          expect(result[:result]).to eq(expected_result)
        end

        it 'creates new user' do
          expect { result }.to change(User, :count).by(1)
        end
      end
    end

    describe 'failure' do
      context 'when params are empty' do
        let(:params) {}
        let(:error_attributes) { { options: { status: :unprocessable_entity, code: 422 } } }

        it 'raises unprocessable error' do
          expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                            .and(having_attributes(error_attributes)))
        end
      end
    end
  end
end
