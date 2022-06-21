# frozen_string_literal: true

module ProjectUpdateSchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:updateProject).schema do
        required(:project).schema do
          required(:id).filled(:str?)
          required(:title).filled(:str?)
        end
        required(:errors).value(:array?, :empty?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).schema do
      required(:updateProject).value(:none?)
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
