# frozen_string_literal: true

require 'pagy/extras/overflow'
require 'pagy/extras/array'

Pagy::VARS[:items] = 30
Pagy::VARS[:overflow] = :empty_page
