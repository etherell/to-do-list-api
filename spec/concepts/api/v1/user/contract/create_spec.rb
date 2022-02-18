# frozen_string_literal: true

RSpec.describe Api::V1::User::Contract::Create do
  let(:contract) { described_class.new(User.new) }
  let(:user_attributes) { attributes_for(:user) }

  describe '#validate' do
    context 'when params are valid' do
      let(:params) { user_attributes }

      it 'returns true' do
        expect(contract.validate(params)).to be true
      end
    end

    context 'when params are invalid' do
      let(:params) { {} }

      it 'returns false' do
        expect(contract.validate(params)).to be false
      end

      context 'with errors' do
        before { contract.validate(params) }

        context 'when all fields are empty' do
          let(:params) { {} }
          let(:errors) do
            {
              username: [find_errors('user', 'username', 'filled?')],
              password: [find_errors('user', 'password', 'filled?')],
              password_confirmation: [find_errors('user', 'password_confirmation', 'filled?')]
            }
          end

          include_examples 'has validation errors'
        end

        describe 'username size' do
          let(:params) { user_attributes.merge(username) }
          let(:username_translate_params) do
            {
              size_left: Constants::Shared::USERNAME_SIZE_RANGE.first,
              size_right: Constants::Shared::USERNAME_SIZE_RANGE.last
            }
          end
          let(:errors) do
            { username: [find_errors('user', 'username', 'size?', username_translate_params)] }
          end

          context 'with short username' do
            let(:username) do
              { username: 'a' * (Constants::Shared::USERNAME_SIZE_RANGE.first - 1) }
            end

            include_examples 'has validation errors'
          end

          context 'with long username' do
            let(:username) do
              { username: 'a' * (Constants::Shared::USERNAME_SIZE_RANGE.last + 1) }
            end

            include_examples 'has validation errors'
          end
        end

        context 'with wrong format of password' do
          let(:params) { user_attributes.merge(password) }
          let(:password) { { password: FFaker::Lorem.characters } }
          let(:errors) do
            { password: [find_errors('user', 'password', 'format?')] }
          end

          include_examples 'has validation errors'
        end

        context 'with wrong password confirmation' do
          let(:params) { user_attributes.merge(password_confirmation) }
          let(:password_confirmation) do
            { password_confirmation: FFaker::Lorem.characters }
          end
          let(:errors) do
            { password_confirmation: [find_errors('user', 'password_confirmation', 'eql?')] }
          end

          include_examples 'has validation errors'
        end

        context 'with not unique username' do
          let(:user) { create(:user) }
          let(:params) { user_attributes.merge(username) }
          let(:username) do
            { username: user.username }
          end
          let(:errors) do
            { username: [find_errors('user', 'username', 'username_unique?')] }
          end

          include_examples 'has validation errors'
        end
      end
    end
  end
end
