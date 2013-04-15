require 'logger'
require 'concur'

require_relative 'go/version'
require_relative 'go/channel'
require_relative 'go/kernel'

module Go
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO
  @@config = Concur::Config.new

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end

  def self.config
    @@config ||= Config.new
  end

end
