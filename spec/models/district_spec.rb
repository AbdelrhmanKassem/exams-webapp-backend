# == Schema Information
#
# Table name: districts
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  governorate :string           not null
#
require 'rails_helper'

RSpec.describe District, type: :model do
  context 'Presence tests' do
    %i[name governorate].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'uniqness tests' do
    subject { FactoryBot.create(:district) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
