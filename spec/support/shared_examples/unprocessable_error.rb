# frozen_string_literal: true

RSpec.shared_examples 'a not found error' do
  let(:error_attributes) do
    { message: I18n.t('errors.not_found', model_name: model_name), options: { status: :not_found, code: 404 } }
  end

  it 'raises not found error' do
    expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                      .and(having_attributes(error_attributes)))
  end
end
