require "chrome_data/version"
require "symboltable"

module ChromeData
  extend self

  def configure
    yield config
  end

  def config
    @@config ||= SymbolTable.new
  end
end