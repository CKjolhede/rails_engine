class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # def self.format_merchants(merchants)
  #   data: books.map do |merchant|
  #     {
  #       id: merchant.id,
  #       type: 'merchant',
  #       attributes: {
  #         name: merchant.name
  #       }
  #     }
  #   end
  # end

end
