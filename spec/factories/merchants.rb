FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    
  end
end

# FactoryBot.define do
#   factory :store do
#     name { Faker::Name.name }
#     after(:build) do |instance|
#       5.times { instance.books << FactoryBot.create(:book) }
#     end 
#   end
# end

# will create 5 book children inside a store. going further you can probably give it a range