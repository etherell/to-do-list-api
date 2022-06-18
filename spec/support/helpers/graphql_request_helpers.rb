# frozen_string_literal: true

module Helpers
  module GraphqlRequestHelpers
    include ActionDispatch::Integration::RequestHelpers

    def graphql_post(query:, variables: {}, headers: {})
      post(
        '/graphql',
        params: {
          query: query,
          variables: normalize_hash(variables).to_json
        },
        headers: headers
      )
    end

    private

    def normalize_hash(hash)
      raise unless hash.is_a?(Hash)

      hash = convert_decimal_values(hash)
      camelize_hash_keys(hash)
    end

    def convert_decimal_values(hash)
      hash.transform_values do |value|
        next convert_decimal_values(value) if value.is_a?(::Hash)

        value.is_a?(::BigDecimal) ? value.to_f : value
      end
    end

    def camelize_hash_keys(hash)
      hash.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    end
  end
end
