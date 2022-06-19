# frozen_string_literal: true

RSpec.shared_examples 'an unprocessable error' do
  let(:error_attributes) { { options: { status: :unprocessable_entity, code: 422 } } }

  it 'raises unprocessable error' do
    expect { result }.to raise_error(an_instance_of(GraphQL::ExecutionError)
                                      .and(having_attributes(error_attributes)))
  end
end
