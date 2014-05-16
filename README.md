# Interkassa Rails

[Interkassa.com](http://new.interkassa.com) modules for easy integration of the payment system with Rails + Mongoid application.

## How to Setup

**Gemfile**:

    gem 'interkassa-rails', github: 'alexkravets/interkassa-rails'

## ENV

Go register at [http://new.interkassa.com](http://new.interkassa.com) and get ```IK_CO_ID``` and ```IK_SECRET_KEY```. Export those to the environment:

    IK_CO_ID:      <your_value>
    IK_SECRET_KEY: <your_value>

## Routes

Add interkassa callbacks mounter somewhere on the top of ```config/routes.rb```

    mount_interkassa_callbacks()

## Order Configuration

Create new initalizer ```config/initializers/interkassa.rb``` and set your order class name, skip this if order model class name is ```Order```:

    Interkassa::Configuration.configure do |config|
      config.order_class_name = 'Order'
    end

In ```Order``` class (or other class) add ```include InterkassaPayment```. This adds relation ship to ```Interkassa::Payment``` model which is changed in interkassa callbacks.

For ```Order``` validation method ```is_ik_payment_valid?``` should be overriden. This is the default one:

    def is_ik_payment_valid?(ik_cur, ik_am)
     ( self.currency == ik_cur and self.total == ik_am )
    end

If ```Order``` is using ```@currency``` and ```@total``` fields don't override.

## Checkout Form

Here is an example of basic checkout form, before using it make sure ```Order``` model has ```total``` and ```description``` fields:

    <form name="payment" method="post" action="https://sci.interkassa.com/" accept-charset="UTF-8">
      <input type="hidden" name="ik_co_id" value="<%= ENV['IK_CO_ID'] %>" />
      <input type="hidden" name="ik_pm_no" value="<%= @order.id %>" />
      <input type="hidden" name="ik_am"    value="<%= @order.total %>" />
      <input type="hidden" name="ik_desc"  value="<%= @order.description %>" />
      <input type="submit" value="Checkout">
    </form>

More more details check out [documentation](https://new.interkassa.com/files/docs/IK2.SCI.Protocol.v0.9.8.ru.pdf).

## Templates

Response templates for **fail** and **success** are placed at ```views/interkassa/callbacks```.

## Author

Alex Kravets @ [slatestudio.com](http://www.slatestudio.com)

## Licence

MIT