require_relative 'minitest_helper'

describe ChromeData do
  before { ChromeData.remove_class_variable :@@config if ChromeData.class_variable_defined? :@@config }

  it 'yields configuration object to block' do
    ChromeData.configure do |config|
      config.foo = 'bar'
    end

    ChromeData.config.foo.must_equal 'bar'
  end

  describe '.cache' do
    before { ChromeData.remove_class_variable :@@cache  if ChromeData.class_variable_defined? :@@cache }

    it 'returns nil with no cache_store config' do
      ChromeData.cache.must_equal nil
    end

    it 'looks up cache with appropriate namespace when cache_store is an array without options hash' do
      ChromeData.config.cache_store = :file_store, '/path/to/cache'

      ActiveSupport::Cache.expects(:lookup_store).with([:file_store, '/path/to/cache', { namespace: 'chromedata' }])

      ChromeData.cache
    end

    it 'looks up cache with appropriate namespace when cache_store is an array with an options hash' do
      ChromeData.config.cache_store = :memory_store, { foo: 'bar' }

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { foo: 'bar', namespace: 'chromedata' }])

      ChromeData.cache
    end

    it 'does not replace user-defined namespace' do
      ChromeData.config.cache_store = :memory_store, { namespace: 'mynamespace' }

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { namespace: 'mynamespace' }])

      ChromeData.cache
    end

    it 'looks up cache with appropriate namespace when cache_store is a symbol' do
      ChromeData.config.cache_store = :memory_store

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { namespace: 'chromedata' }])

      ChromeData.cache
    end
  end
end
