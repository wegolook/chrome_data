module ChromeData::Caching
  # Creates CacheStore object based on config.cache_store options
  # reverse merges 'chromedata' namespace to options hash
  def _cache_store
    return @@_cache_store if defined? @@_cache_store

    if ChromeData.config.cache_store
      cache_opts = { namespace: 'chromedata' }

      if ChromeData.config.cache_store.is_a?(Array)
        if ChromeData.config.cache_store.last.is_a?(Hash)
          ChromeData.config.cache_store.last.reverse_merge! cache_opts
        else
          ChromeData.config.cache_store << cache_opts
        end
      elsif ChromeData.config.cache_store.is_a?(Symbol)
        ChromeData.config.cache_store = [ChromeData.config.cache_store, cache_opts]
      end

      @@_cache_store = ActiveSupport::Cache.lookup_store(ChromeData.config.cache_store)
    end
  end

  def cache(key, &blk)
    if ChromeData._cache_store
      ChromeData._cache_store.fetch key, &blk
    else
      blk.call
    end
  end
end