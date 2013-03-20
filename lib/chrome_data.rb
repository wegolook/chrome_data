require "chrome_data/version"
require "chrome_data/base"
require "chrome_data/division"
require "chrome_data/model"
require "chrome_data/style"

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
  def config
    @@config ||= SymbolTable.new country: 'US', language: 'en'
  end
end