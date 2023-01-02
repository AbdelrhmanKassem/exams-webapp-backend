# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  district_id :bigint           not null
#
require 'rails_helper'

RSpec.describe School, type: :model do
  context 'Presence tests' do
    %i[name].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
  
  context 'District Association' do
    it { is_expected.to belong_to(:district) }
  end
end
