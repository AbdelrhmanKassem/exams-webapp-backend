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
            admin = FactoryBot.build(:user)
            admin.role = 'admin'
            admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                name: school.name,
                district: school.district,
                governorate: school.governorate
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
            admin = FactoryBot.build(:user)
            admin.role = 'admin'
            admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                district: school.district,
                governorate: school.governorate
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
            not_admin = FactoryBot.build(:user)
            not_admin.role = 'examiner'
            not_admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            school = FactoryBot.build(:school)
            post '/schools', params: {
              school: {
                name: school.name,
                district: school.district,
                governorate: school.governorate
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
                district: school.district,
                governorate: school.governorate
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
