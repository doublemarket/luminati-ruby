# frozen_string_literal: true

require "luminati"
require "simplecov"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

SimpleCov.start do
  enable_coverage :branch
end

def fixture(file)
  File.new(File.expand_path("fixtures", __dir__) + "/" + file)
end
