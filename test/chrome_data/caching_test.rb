require_relative '../minitest_helper'

describe ChromeData::Caching do
  before do
    ChromeData.remove_class_variable :@@config if ChromeData.class_variable_defined? :@@config
    ChromeData::Caching.remove_class_variable :@@_cache_store  if ChromeData::Caching.class_variable_defined? :@@_cache_store
  end

  describe '.cache' do
    it 'caches request when caching is on' do
      ChromeData.config.cache_store = :memory_store

      foo = stub('foo')
      foo.expects(:bar).once.returns 'bar'

      2.times do
        ChromeData.cache 'foo' do
          foo.bar
        end.must_equal 'bar'
      end
    end

    it 'does not cache request when caching is off' do
      foo = stub('foo')
      foo.expects(:bar).twice.returns 'bar'

      2.times do
        ChromeData.cache 'foo' do
          foo.bar
        end.must_equal 'bar'
      end
    end
  end

  describe '._cache_store' do
    before { ChromeData::Caching.remove_class_variable :@@_cache_store  if ChromeData::Caching.class_variable_defined? :@@_cache_store }

    it 'returns nil with no cache_store config' do
      ChromeData._cache_store.must_equal nil
    end

    it 'looks up cache with appropriate namespace when cache_store is an array without options hash' do
      ChromeData.config.cache_store = :file_store, '/path/to/cache'

      ActiveSupport::Cache.expects(:lookup_store).with([:file_store, '/path/to/cache', { namespace: 'chromedata' }])

      ChromeData._cache_store
    end

    it 'looks up cache with appropriate namespace when cache_store is an array with an options hash' do
      ChromeData.config.cache_store = :memory_store, { foo: 'bar' }

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { foo: 'bar', namespace: 'chromedata' }])

      ChromeData._cache_store
    end

    it 'does not replace user-defined namespace' do
      ChromeData.config.cache_store = :memory_store, { namespace: 'mynamespace' }

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { namespace: 'mynamespace' }])

      ChromeData._cache_store
    end

    it 'looks up cache with appropriate namespace when cache_store is a symbol' do
      ChromeData.config.cache_store = :memory_store

      ActiveSupport::Cache.expects(:lookup_store).with([:memory_store, { namespace: 'chromedata' }])

      ChromeData._cache_store
    end
  end
end
