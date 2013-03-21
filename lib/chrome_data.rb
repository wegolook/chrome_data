require "chrome_data/version"
require "chrome_data/base"
require "chrome_data/division"
require "chrome_data/model"
require "chrome_data/style"
require "chrome_data/model_year"
require 'active_support/cache'

require "symboltable"

module ChromeData
  extend self

  def configure
    yield config
  end

  # Valid options:
  #   account_number
  #   account_secret
  #   country (default: 'US')
  #   language (default: 'en')
  #   cache_store
  def config
    @@config ||= SymbolTable.new country: 'US', language: 'en'
  end

  # Creates CacheStore object based on config.cache_store options
  # reverse merges 'chromedata' namespace to options hash
  def cache
    return @@cache if defined? @@cache

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

      @@cache = ActiveSupport::Cache.lookup_store(ChromeData.config.cache_store)
    end
  end
end