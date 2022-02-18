# frozen_string_literal: true

module Api::V1::User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    pass Macro::PrepareParams(main_key: :user)
    step Contract::Build(constant: Api::V1::User::Contract::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    pass Macro::Semantic(success: :created)
  end
end
