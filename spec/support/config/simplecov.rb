# frozen_string_literal: true

SimpleCov.start do
  enable_coverage :branch
  add_filter [
    '/spec/',
    '/config/',
    '/vendor/',
    'app/services',
    'app/controllers/graphql_controller.rb',
    'app/graphql/to_do_list_api_schema.rb',
    'app/controllers/concerns/default_endpoint.rb',
    'lib/macro/schema.rb'
  ]
  minimum_coverage 100
end
