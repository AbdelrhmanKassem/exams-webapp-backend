# == Schema Information
#
# Table name: branches
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
require 'rails_helper'

RSpec.describe Branch, type: :model do
  context 'Presence tests' do
    %i[name].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'uniqness tests' do
    subject { FactoryBot.create(:branch) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
