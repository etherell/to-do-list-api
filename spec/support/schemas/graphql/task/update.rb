# frozen_string_literal: true

module TaskUpdateSchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:updateTask).schema do
        required(:task).schema do
          required(:id).filled(:str?)
          required(:description).filled(:str?)
          required(:deadline).filled(:str?)
          required(:position).filled(:int?)
          required(:isDone).filled(:bool?)
        end
        required(:errors).value(:array?, :empty?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).schema do
      required(:updateTask).value(:none?)
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
