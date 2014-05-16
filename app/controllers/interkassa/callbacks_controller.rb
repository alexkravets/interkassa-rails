class Interkassa::CallbacksController < ApplicationController
  # disabled CSRF check all requests are sent by Interkassa
  skip_before_filter :verify_authenticity_token

  # check if specified order exists and
  # update attributes for payment
  def fail
    payment  = Interkassa::Payment.find_or_initialize_by(order_id: params['ik_pm_no'])
    @order   = payment.order
    if @order
      payment.update_attributes(permit_params)
    else
      logger.debug "Interkassa error: order not found"
      render text: 'Order not found', status: 500
    end
  end

  # check if specified order exists
  def success
    @order = order_class.find(params['ik_pm_no'])
    if not @order
      logger.debug "Interkassa error: order not found"
      render text: 'Order not found', status: 500
    end
  end

  def interaction
    if not is_request_valid?
      logger.debug "Interkassa error: invalid signature"
      render text: 'Invalid signature', status: 500
    elsif not is_ik_id_valid?
      logger.debug "Interkassa error: Invalid ik_id"
      render text: 'Invalid ik_id', status: 500
    else

      @order = order_class.find(params['ik_pm_no'])
      if not @order
        logger.debug "Interkassa error: order not found"
        render text: 'Order not found', status: 500
      else

        ik_cur = params['ik_cur']
        ik_am  = params['ik_am'].to_f

        if @order.is_ik_payment_valid?(ik_cur, ik_am)
          payment = Interkassa::Payment.find_or_initialize_by(order_id: params['ik_pm_no'])
          payment.update_attributes(permit_params)

          payment.order.paid!

          render text: :ok, status: 200
        else
          logger.debug "Interkassa error: invalid payment attributes"
          render text: 'Invalid payment attributes', status: 500
        end
      end

    end
  end

  private

  def order_class
    Rails.configuration.interkassa.order_class_name.constantize
  end

  def is_request_valid?
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

  def permit_params
    params.permit(:ik_co_id,
                  :ik_inv_id,
                  :ik_inv_st,
                  :ik_inv_crt,
                  :ik_inv_prc,
                  :ik_pm_no,
                  :ik_pw_via,
                  :ik_am,
                  :ik_cur,
                  :ik_co_rfn,
                  :ik_ps_price,
                  :ik_desc,
                  :action,
                  :controller)
  end
end