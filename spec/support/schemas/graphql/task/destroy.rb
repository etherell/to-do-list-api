# frozen_string_literal: true

module TaskDestroySchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:destroyTask).schema do
        required(:result).filled(:str?)
        required(:errors).value(:array?, :empty?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).schema do
      required(:destroyTask).value(:none?)
    end
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