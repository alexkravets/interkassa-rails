module Interkassa
  class Engine < ::Rails::Engine
    config.interkassa = ActiveSupport::OrderedOptions.new
    config.interkassa.order_class_name = 'Order'
  end
end