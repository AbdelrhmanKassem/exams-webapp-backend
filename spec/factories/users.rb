# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  role_id            :bigint           not null
#  first_name         :string           not null
#  last_name          :string           not null
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  jti                :string           not null
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    last_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    email { Faker::Internet.unique.safe_email }
    password { 'Test@123123' }
    role
  end

  factory :admin_user, parent: :user do
    role { Role.find_or_create_by(name: 'admin') }
  end

  factory :examiner_user, parent: :user do
    role { Role.find_or_create_by(name: 'examiner') }
  end
end
