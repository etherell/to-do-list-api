# frozen_string_literal: true

module CommentCreateSchema
  Success = Dry::Validation.Schema do
    required(:data).schema do
      required(:createComment).schema do
        required(:comment).schema do
          required(:id).filled(:str?)
          required(:text).filled(:str?)
          required(:image).filled(:str?)
        end
        required(:errors).value(:array?, :empty?)
      end
    end
  end

  Error = Dry::Validation.Schema do
    required(:data).schema do
      required(:createComment).value(:none?)
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
