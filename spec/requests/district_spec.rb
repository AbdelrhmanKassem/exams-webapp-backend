# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'districts', type: :request do
  describe 'Bramch Api' do
    path '/districts' do
      get 'Get Districts' do
        security [Bearer: []]
        tags 'District'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of districts' do
          let(:page) { 1 }
          it 'Should respond with a page of districts in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            FactoryBot.create_list(:district, 15)
            get '/districts', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('district_index')
            expect(response.parsed_body['districts'].length).to eq([Kaminari.config.default_per_page, District.all.count].min)
          end
          it 'Should respond with a page of districts even if user is an examiner, status: 200' do
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            headers = { Authorization: token }
            FactoryBot.create_list(:district, 15)
            get '/districts', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('district_index')
            expect(response.parsed_body['districts'].length).to eq([Kaminari.config.default_per_page, District.all.count].min)
          end
        end

        response '401', 'Failed (No or invalid auth header)' do
          let(:page) { 1 }
          it 'Fail due to absent auth token' do
            get '/districts'
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end

          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/districts', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end
        end
      end
    end
  end
end
