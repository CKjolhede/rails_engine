module ExceptionHandler

  def error_conditions
    empty_params || 
    include_name ||
    neg_min ||
    neg_max ||
    min_over_max ||
    min_is_max
  end

  def error_response
    empty_params? ErrorSerializer.format_error(exception_response[:empty_params], status: 400
    include_name? ErrorSerializer.format_error(exception_response[:include_name], status: 400
    neg_min? ErrorSerializer.format_error(exception_response[:neg_min], status: 400
    neg_max? ErrorSerializer.format_error(exception_response[:neg_max], status: 400
    min_over_max? ErrorSerializer.format_error(exception_response[:min_over_max] status: 400
    min_is_max? ErrorSerializer.format_error(exception_response[:min_is_max]status: 400
  end

  exception_response = Hash.new(
    empty_params: "Parameters cannot be missing",
    include_name: "Cannot send name and price",
    neg_min: "min price less than 0",
    neg_max: "max price less than 0",
    min_over_max: 'max price less than min price',
    min_is_max: 'min price and max price cannot be the same')
end