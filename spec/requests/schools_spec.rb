# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'schools', type: :request do
  describe 'School Api' do
    path '/schools' do
      post 'Create School' do
        security [Bearer: []]
        tags 'School'
        consumes 'application/json'
        parameter name: :school, in: :body, schema: { '$ref' => '#/components/schemas/create_school_request' }

        response '201 ', 'Success' do
          it 'Should create school successfully and return created school object, status: 201' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            district = FactoryBot.create(:district)
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                name: school.name,
                district_id: district.id
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('school')
            school = School.find_by(id: response.parsed_body['id'])
            expect(school).not_to be_nil
          end
        end

        response '422', 'Failed (invalid school data)' do
          it 'Fail due to school model validatoins' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            district = FactoryBot.create(:district)
            post '/schools', params: {
              school: {
                district_id: district.id
              }
            }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to be_has_key('name')
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                name: school.name,
                district_id: 1
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                name: school.name,
                district_id: 1
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end
        end
      end

      get 'Get Schools' do
        security [Bearer: []]
        tags 'School'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of schools' do
          let(:page) { 1 }
          it 'Should respond with a page of schools in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            district = FactoryBot.create(:district)
            FactoryBot.create_list(:school, 15, district_id: district.id)
            get '/schools', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('school_index')
            expect(response.parsed_body['schools'].length).to eq([Kaminari.config.default_per_page, School.all.count].min)
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          let(:page) { 1 }
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            get '/schools', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/schools', headers: headers
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
