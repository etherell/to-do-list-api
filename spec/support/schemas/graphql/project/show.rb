# frozen_string_literal: true

module ProjectShowSchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:project).schema do
        required(:id).filled(:str?)
        required(:title).filled(:str?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).maybe(:hash?).value(:none?)
    required(:errors).each do
      schema do
        required(:message).filled(:str?)
        required(:locations).filled(:array?).each(:hash?)
        required(:path).filled(:array?).each(:str?)
        required(:status).filled(:str?)
        required(:code).filled(:int?)
      end
    end
  end
end
