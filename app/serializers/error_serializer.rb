class ErrorSerializer
  include JSONAPI::Serializer

  def self.num_error(message)
    format_error(message)[:data]
  end

  def self.format_error(message)
  {data: 
        {error: message }
  }
  end
end
