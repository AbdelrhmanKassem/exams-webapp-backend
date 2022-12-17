# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  username               :string
#  first_name             :string
#  last_name              :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  jti                    :string           not null
#
FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 3..30) }
    first_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    last_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    email { Faker::Internet.unique.safe_email }
    password { 'Test@123123' }
    role { User.roles.keys.sample.to_s }
  end
end
