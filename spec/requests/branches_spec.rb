# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'branches', type: :request do
  describe 'Bramch Api' do
    path '/branches' do
      get 'Get Branches' do
        security [Bearer: []]
        tags 'Branch'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of branches' do
          let(:page) { 1 }
          it 'Should respond with a page of branches in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            FactoryBot.create_list(:branch, 15)
            get '/branches', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('branch_index')
            expect(response.parsed_body['branches'].length).to eq([Kaminari.config.default_per_page, Branch.all.count].min)
          end
          it 'Should respond with a page of branches even if user is an examiner, status: 200' do
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            headers = { Authorization: token }
            FactoryBot.create_list(:branch, 15)
            get '/branches', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('branch_index')
            expect(response.parsed_body['branches'].length).to eq([Kaminari.config.default_per_page, Branch.all.count].min)
          end
        end

        response '401', 'Failed (No or invalid auth header)' do
          let(:page) { 1 }
          it 'Fail due to absent auth token' do
            get '/branches'
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end

          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/branches', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end
        end
      end


      post 'Create Branch' do
        security [Bearer: []]
        tags 'Branch'
        consumes 'application/json'
        parameter name: :branch, in: :body, schema: { '$ref' => '#/components/schemas/create_branch_request' }

        response '201 ', 'Success' do
          it 'Should create branch successfully and return created branch object, status: 201' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            post '/branches', params: {
              branch: {
                name: 'Branch 1'
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('branch')
            branch = Branch.find_by(id: response.parsed_body['id'])
            expect(branch).not_to be_nil
          end
        end

        response '422', 'Failed (invalid branch data)' do
          it 'Fail due to branch model validatoins' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            post '/branches', params: {
              branch: {
                nameeee: 'wrong key'
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
            post '/branches', params: {
              branch: {
                name: 'Branch 2'
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            post '/branches', params: {
              branch: {
                name: 'Branch 3',
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
