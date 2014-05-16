# Interkassa Rails

[Interkassa.com](http://new.interkassa.com) modules for easy integration of the payment system with Rails application.

## How to Setup

**Gemfile**:

    gem 'interkassa-rails', github: 'alexkravets/interkassa-rails'

## ENV

Go register at [http://new.interkassa.com](http://new.interkassa.com) and get ```IK_CO_ID``` and ```IK_SECRET_KEY```. Export those to the environment:

    IK_CO_ID:      <your_value>
    IK_SECRET_KEY: <your_value>

## Initializer

Create new initalizer ```config/initializers/interkassa.rb``` and set your order class name:

  Interkassa.configure do |config|
    config.order_class_name = Order
  end

## Model

## Routes

Add interkassa callbacks mounter somewhere on the top of ```config/routes.rb```

    mount_interkassa_callbacks()

## Licence

MIT