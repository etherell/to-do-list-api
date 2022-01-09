# frozen_string_literal: true

module Helpers
  module ValidationTranslatesHelper
    def find_errors(namespace, field, rule, translate_params = {})
      I18n.t("errors.rules.#{namespace}.rules.#{field}.#{rule}", translate_params)
    end
  end
end
