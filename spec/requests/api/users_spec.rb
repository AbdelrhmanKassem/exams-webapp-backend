# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'users', type: :request do
  describe 'User Api' do
    path '/users/login' do
      post 'Login User' do
        tags 'User'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/user_login_request' }

        response '200', 'Success responses' do
          it 'Should login successfully and return JWT token in header if credentials is valid' do
            user = FactoryBot.create(:user)
            post '/users/login', params: {
              user: {
                email: user.email, password: user.password
              }
            }
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body['user']['email']).to eq(user.email)
            expect(response.parsed_body['status']['message']).to eq(I18n.t('devise.confirmations.logged_in'))
            expect(response.headers).to be_has_key('Authorization')
            expect(response.headers['Authorization']).to include('Bearer ')

            # Check that the token actally works, also that current_user instance was set
            get '/current_user', headers: { Authorization: response.headers['Authorization'] }
            expect(response).to have_http_status(:ok)
            expect(response.parsed_body['email']).to eq(user.email)
            expect(response.content_type).to include('application/json')
          end
        end
        response '401', 'Failed responses' do
          it 'Login failed and return failure message' do
            user = FactoryBot.create(:user)
            post '/users/login', params: {
              user: {
                email: user.email, password: 'Invalid'
              }
            }
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
            expect(response.headers).to_not be_has_key('Authorization')
          end
        end
      end
    end

    path '/users/logout' do
      delete 'Logout user' do
        security [Bearer: []]
        tags 'User'
        consumes 'application/json'
        response '200', 'Success cases' do
          it 'Should logout successfully and return success message, status: 200' do
            user = FactoryBot.create(:user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', user)
            headers = { Authorization: token }
            delete '/users/logout', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.parsed_body['message']).to eq(I18n.t('devise.confirmations.logged_out'))
            expect(response.content_type).to include('application/json')

            # Make sure the token was invalidated
            get '/current_user', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
            expect(response.content_type).to include('application/json')
          end
        end
        response '401', 'Failed cases' do
          it 'Should fail to logout and return unauthorized error message, status: 401' do
            FactoryBot.create(:user)
            headers = { Authorization: 'invalid' }
            delete '/users/logout', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.log_out'))
            expect(response.content_type).to include('application/json')
          end
        end
      end
    end
  end
end
