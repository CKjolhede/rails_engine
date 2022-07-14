class ErrorSerializer
  include JSONAPI::Serializer
  attributes :message, :merchant_id, :item_id, :status
end
