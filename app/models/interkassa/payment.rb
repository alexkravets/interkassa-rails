class Interkassa::Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  # attributes
  field :ik_co_id
  field :ik_inv_id
  field :ik_inv_st
  field :ik_inv_crt,  type: DateTime
  field :ik_inv_prc,  type: DateTime
  field :ik_pm_no
  field :ik_pw_via
  field :ik_am,       type: Float
  field :ik_cur
  field :ik_co_rfn
  field :ik_ps_price, type: Float
  field :ik_desc
  field :action
  field :controller

  # relations
  belongs_to :order, class_name: Rails.configuration.interkassa.order_class_name

  # helpers
  def failed?
    not success?
  end

  def success?
    @ik_inv_st == 'success'
  end
end