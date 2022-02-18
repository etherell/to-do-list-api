# frozen_string_literal: true

class PrepareParamsService
  def initialize(params)
    @params = params
  end

  def self.prepare(params, *args)
    new(params).prepare(*args)
  end

  def prepare(main_key:, secondary_key: nil, specific_keys: [])
    return strip_by_main_key(main_key) if !secondary_key && specific_keys.empty?
    return strip_by_secondary_key(main_key, secondary_key) if secondary_key && specific_keys.empty?
    return strip_by_specific_keys(main_key, specific_keys) if specific_keys.any?
  end

  private

  attr_reader :params

  def strip_by_main_key(main_key)
    return unless params[main_key]

    params[main_key] = transform_params(params[main_key])
  end

  def strip_by_secondary_key(main_key, secondary_key)
    return unless params[main_key] && params[main_key][secondary_key]

    params[main_key][secondary_key] = transform_params(params[main_key][secondary_key])
  end

  def strip_by_specific_keys(main_key, specific_keys)
    return unless params[main_key]

    specific_keys.each do |k|
      params[main_key][k] = params[main_key][k].strip if params[main_key].key?(k)
    end
  end

  def transform_params(specific_params)
    specific_params.transform_values { |v| v.is_a?(String) ? v.strip : v }
  end
end
