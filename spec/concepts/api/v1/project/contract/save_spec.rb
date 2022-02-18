# frozen_string_literal: true

RSpec.describe Api::V1::Project::Contract::Save do
  let(:contract) { described_class.new(user.projects.build) }
  let(:project_attributes) { attributes_for(:project) }
  let(:user) { create(:user) }

  describe '#validate' do
    context 'when params are valid' do
      let(:params) { project_attributes }

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
            { title: [find_errors('project', 'title', 'filled?')] }
          end

          include_examples 'has validation errors'
        end

        describe 'title size' do
          let(:params) { project_attributes.merge(title) }
          let(:title_translate_params) do
            {
              size_left: Constants::Shared::PROJECT_TITLE_SIZE_RANGE.first,
              size_right: Constants::Shared::PROJECT_TITLE_SIZE_RANGE.last
            }
          end
          let(:errors) do
            { title: [find_errors('project', 'title', 'size?', title_translate_params)] }
          end

          context 'with short title' do
            let(:title) do
              { title: 'a' * (Constants::Shared::PROJECT_TITLE_SIZE_RANGE.first - 1) }
            end

            include_examples 'has validation errors'
          end

          context 'with long title' do
            let(:title) do
              { title: 'a' * (Constants::Shared::PROJECT_TITLE_SIZE_RANGE.last + 1) }
            end

            include_examples 'has validation errors'
          end
        end
      end
    end
  end
end
