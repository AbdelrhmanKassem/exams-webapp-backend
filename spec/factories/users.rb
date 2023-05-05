# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  role_id            :bigint           not null
#  full_name          :string           not null
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  jti                :string           not null
#
FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
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

  factory :proctor_user, parent: :user do
    role { Role.find_or_create_by(name: 'proctor') }
  end
end
