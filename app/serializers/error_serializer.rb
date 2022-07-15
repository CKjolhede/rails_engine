class ErrorSerializer
  include JSONAPI::Serializer

  def self.format_error(message, status)
  {data: 
        {error: message }
  }
  status[:status] = status
  end

  def self.with_name(status)
    message = "cannot send name with min_price"
    self.format_error(message, status)
  end

  def self.neg_min(status)
    message = "min_price less than 0"
    format_error(message, status)
  end

  def self.invalid(status)
    message = 'invalid user input'
    format_error(message, status)
  end

  def self.is_nil(status)
    message = 'No items found'
    format_error(message, status)
  end
end
