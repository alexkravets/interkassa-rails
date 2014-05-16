module InterkassaPayment
  extend ActiveSupport::Concern

  included do
    # relations
    #has_one :ik_payment, class_name: "Interkassa::Payment"
  end
end