require_relative 'minitest_helper'

describe ChromeData do
  before { ChromeData.remove_class_variable :@@config if ChromeData.class_variable_defined? :@@config }

  it 'yields configuration object to block' do
    ChromeData.configure do |config|
      config.foo = 'bar'
    end

    ChromeData.config.foo.must_equal 'bar'
  end
end
