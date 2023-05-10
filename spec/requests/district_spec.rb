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

      post 'Create District' do
        security [Bearer: []]
        tags 'District'
        consumes 'application/json'
        parameter name: :district, in: :body, schema: { '$ref' => '#/components/schemas/create_district_request' }

        response '201 ', 'Success' do
          it 'Should create district successfully and return created district object, status: 201' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            district = FactoryBot.build(:district)
            post '/districts', params: {
              district: {
                name: district.name,
                governorate: district.governorate
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('district')
            district = District.find_by(id: response.parsed_body['id'])
            expect(district).not_to be_nil
          end
        end

        response '422', 'Failed (invalid district data)' do
          it 'Fail due to district model validatoins' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            district = FactoryBot.build(:district)
            post '/districts', params: {
              district: {
                name: district.name
              }
            }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to be_has_key('governorate')
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            district = FactoryBot.build(:district)
            post '/districts', params: {
              district: {
                name: district.name,
                governorate: district.governorate
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            district = FactoryBot.build(:district)
            post '/districts', params: {
              district: {
                name: district.name,
                governorate: district.governorate
              }
            }, headers: headers
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
