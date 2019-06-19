FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'foo.name@andela.com' }
    password { 'foobar8889583539845' }
  end
end