class Interkassa::CallbacksController < ActionController::Base
  # disabled
  skip_before_filter :verify_authenticity_token
  before_filter      :save_payment_data, only: [ :pending, :fail ]

  def fail
  end

  def pending
  end

  def success
    order_int_id = params['ik_pm_no']
    redirect_to order_path(order_int_id)
  end

  def interaction
    if is_signature_valid? and is_ik_id_valid?

      @order = Order.where(int_id: params['ik_pm_no']).first

      if @order and is_order_valid?
        @order.payment_id           = params['ik_inv_id']
        @order.payment_status       = params['ik_inv_st']
        @order.payment_created_at   = params['ik_inv_crt']
        @order.payment_processed_at = params['ik_inv_prc']
        # TODO: do I need to save "ik_co_prs_id"=>"204864581293" ???
        # https://new.interkassa.com/files/docs/IK2.SCI.Protocol.v0.9.8.ru.pdf

        @order.save

        head :ok
      else
        puts "\nerror 2"
        render text: 'ERROR 02 - Invalid request', status: 500
      end
    else
      puts "\nerror 1"
      render text: 'ERROR 01 - Invalid request', status: 500
    end
  end

  private

  def save_payment_data
    order_int_id = params['ik_pm_no']
    @order = Order.where(int_id: order_int_id).first

    if @order
      @order.payment_id           = params['ik_inv_id']
      @order.payment_status       = params['ik_inv_st']
      @order.payment_created_at   = params['ik_inv_crt']

      @order.save
    else
      puts "\nerror 0"
      render text: 'ERROR 00 - Invalid request', status: 500
    end
  end

  def is_signature_valid?
    ik_sign      = params['ik_sign'].gsub("\n", '')
    ik_secret    = ENV['IK_SECRET_KEY']
    hash_keys    = params.keys.select{ |k,v| k.starts_with? 'ik_' and k != 'ik_sign' }.sort
    hash_values  = hash_keys.collect{ |k| params[k] } + [ ik_secret ]
    hash_param   = hash_values.join(':')
    request_sign = Base64.encode64(Digest::MD5.digest(hash_param)).gsub("\n", '')
    ik_sign == request_sign
  end

  def is_ik_id_valid?
    params['ik_co_id'] == ENV['IK_CO_ID']
  end

  def is_order_valid?
    ( @order.rate_unit == params['ik_cur'] and @order.total_amount == params['ik_am'].to_f )
  end
end