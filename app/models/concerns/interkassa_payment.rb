module InterkassaPayment
  extend ActiveSupport::Concern

  included do
    # relations
    has_one :ik_payment, class_name: "Interkassa::Payment"

    def is_ik_payment_valid?(ik_cur, ik_am)
     ( self.currency == ik_cur and self.total == ik_am )
    end
  end
end