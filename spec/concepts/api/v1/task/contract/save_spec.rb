# frozen_string_literal: true

RSpec.describe Api::V1::Task::Contract::Save do
  let(:contract) { described_class.new(project.tasks.build) }
  let(:task_attributes) { attributes_for(:task) }
  let(:project) { create(:project) }

  describe '#validate' do
    context 'when params are valid' do
      let(:params) { task_attributes }

      it 'returns true' do
        expect(contract.validate(params)).to be true
      end
    end

    context 'when params are invalid' do
      before { contract.validate(params) }

      context 'when all fields are empty' do
        let(:params) { {} }
        let(:errors) do
          { description: [find_errors('task', 'description', 'filled?')] }
        end

        include_examples 'has validation errors'
      end

      describe 'description size' do
        let(:params) { task_attributes.merge(description) }
        let(:description_translate_params) do
          {
            size_left: Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE.first,
            size_right: Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE.last
          }
        end
        let(:errors) do
          { description: [find_errors('task', 'description', 'size?', description_translate_params)] }
        end

        context 'with short description' do
          let(:description) do
            { description: 'a' * (Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE.first - 1) }
          end

          include_examples 'has validation errors'
        end

        context 'with long description' do
          let(:description) do
            { description: 'a' * (Constants::Shared::TASK_DESCRIPTION_SIZE_RANGE.last + 1) }
          end

          include_examples 'has validation errors'
        end
      end
    end
  end
end
