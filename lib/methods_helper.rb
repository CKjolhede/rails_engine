module MethodHelper

  def empty_params
    
  end

  def invalid_id
    Merchant.find(:id).exists? == false
  end
end 