# frozen_string_literal: true

RSpec.describe Graphql::Task::Contract::Update do
  let(:contract) { described_class.new(task) }
  let(:task_attributes) { attributes_for(:task) }
  let(:task) { create(:task, project: project) }
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
        let(:params) { { description: '', deadline: '', is_done: '', position: '' } }
        let(:errors) do
          {
            description: [find_errors('task', 'description', 'filled?')],
            deadline: [find_errors('task', 'deadline', 'filled?')],
            position: [find_errors('task', 'position', 'filled?')],
            is_done: [find_errors('task', 'is_done', 'filled?')]
          }
        end

        include_examples 'has validation errors'
      end

      context 'with wrong deadline format' do
        let(:params) { task_attributes.merge(deadline) }
        let(:deadline) do
          { deadline: FFaker::Lorem.word }
        end
        let(:errors) do
          { deadline: [find_errors('task', 'deadline', 'date_time?')] }
        end

        include_examples 'has validation errors'
      end

      context 'with wrong is done format' do
        let(:params) { task_attributes.merge(is_done) }
        let(:is_done) do
          { is_done: FFaker::Lorem.word }
        end
        let(:errors) do
          { is_done: [find_errors('task', 'is_done', 'bool?')] }
        end

        include_examples 'has validation errors'
      end

      context 'with wrong position format' do
        let(:params) { task_attributes.merge(position) }
        let(:position) do
          { position: FFaker::Lorem.word }
        end
        let(:errors) do
          { position: [find_errors('task', 'position', 'int?')] }
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
