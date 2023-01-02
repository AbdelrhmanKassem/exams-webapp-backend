# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'roles', type: :request do
  describe 'Bramch Api' do
    path '/roles' do
      get 'Get Roles' do
        security [Bearer: []]
        tags 'Role'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of roles' do
          let(:page) { 1 }
          it 'Should respond with a page of roles in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            FactoryBot.create_list(:role, 15)
            get '/roles', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('role_index')
            expect(response.parsed_body['roles'].length).to eq([Kaminari.config.default_per_page, Role.all.count].min)
          end
        end
        response '401', 'Failed (No auth header or not an admin)' do
          let(:page) { 1 }
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            get '/roles', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/roles', headers: headers
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
