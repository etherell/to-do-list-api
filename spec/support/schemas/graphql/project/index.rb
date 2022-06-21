# frozen_string_literal: true

module ProjectIndexchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:projects).each do
        schema do
          required(:id).filled(:str?)
          required(:title).filled(:str?)
          required(:tasks).each do
            required(:id).filled(:str?)
            required(:description).filled(:str?)
            required(:deadline).filled(:str?)
            required(:position).filled(:int?)
            required(:isDone).filled(:bool?)
            required(:comments).each do
              required(:id).filled(:str?)
              required(:text).filled(:str?)
              required(:image).filled(:str?)
            end
          end
        end
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
