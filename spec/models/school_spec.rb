# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string
#  governorate :string
#  district    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe School, type: :model do
  context 'Presence tests' do
    %i[name governorate district].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
end
