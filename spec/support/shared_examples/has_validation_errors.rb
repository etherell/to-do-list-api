# frozen_string_literal: true

RSpec.shared_examples 'has validation errors' do
  it 'has validation errors' do
    expect(contract.errors.messages).to eq(errors)
  end
end
