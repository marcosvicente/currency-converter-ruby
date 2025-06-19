if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start do
    add_filter %r{^/test/}
  end
end