module Interkassa
  class Configuration
    def self.configure
      yield ::Rails.configuration.interkassa
    end
  end
end