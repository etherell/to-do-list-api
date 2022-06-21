# frozen_string_literal: true

RSpec.describe Graphql::Comment::Contract::Create do
  let(:contract) { described_class.new(task.comments.build) }
  let(:comment_attributes) { attributes_for(:comment, :with_base_64_image) }
  let(:task) { create(:task) }

  describe '#validate' do
    context 'when params are valid' do
      let(:params) { comment_attributes }

      it 'returns true' do
        expect(contract.validate(params)).to be true
      end
    end

    context 'when params are invalid' do
      before { contract.validate(params) }

      context 'when text is empty' do
        let(:params) { { text: '', image: '' } }
        let(:errors) do
          { text: [find_errors('comment', 'text', 'filled?')] }
        end

        include_examples 'has validation errors'
      end

      describe 'Text size' do
        let(:params) { comment_attributes.merge(text) }
        let(:text_translate_params) do
          {
            size_left: Constants::Shared::COMMENT_TEXT_SIZE_RANGE.first,
            size_right: Constants::Shared::COMMENT_TEXT_SIZE_RANGE.last
          }
        end
        let(:errors) do
          { text: [find_errors('comment', 'text', 'size?', text_translate_params)] }
        end

        context 'with short description' do
          let(:text) do
            { text: 'a' * (Constants::Shared::COMMENT_TEXT_SIZE_RANGE.first - 1) }
          end

          include_examples 'has validation errors'
        end

        context 'with long description' do
          let(:text) do
            { text: 'a' * (Constants::Shared::COMMENT_TEXT_SIZE_RANGE.last + 1) }
          end

          include_examples 'has validation errors'
        end
      end
    end
  end
end
