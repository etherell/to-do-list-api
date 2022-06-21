# frozen_string_literal: true

module SessionCreateSchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:createSession).schema do
        required(:session).schema do
          required(:access).filled(:str?)
          required(:refresh).filled(:str?)
        end
        required(:errors).value(:array?, :empty?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).schema do
      required(:createSession).value(:none?)
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
