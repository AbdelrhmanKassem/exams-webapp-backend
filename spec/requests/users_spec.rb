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

        response '200', 'Success' do
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
        response '401', 'Failed (Incorrect Credentials)' do
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
        response '200', 'Success' do
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
        response '401', 'Failed (Already logged out / invalid token)' do
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

    path '/users' do
      post 'Create User' do
        security [Bearer: []]
        tags 'User'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/create_user_request' }

        response '201 ', 'Success' do
          it 'Should create user successfully and return success message, status: 201' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            role = FactoryBot.create(:role)
            user = FactoryBot.build(:user)
            post '/users', params: {
              user: {
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                role_id: role.id
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body['message']).to eq(I18n.t('messages.success', operation: 'user created'))
            user = User.find_by(email: user.email)
            expect(user).not_to be_nil
            expect(PasswordResetToken.find_by(user_id: user.id)).not_to be_nil
          end
        end

        response '422', 'Failed (invalid user data)' do
          it 'Fail due to user model validatoins' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            user = FactoryBot.build(:user)
            post '/users', params: {
              user: {
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                role_id: 55555555
              }
            }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']['role']).to include('must exist')
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            role = FactoryBot.create(:role)
            user = FactoryBot.build(:user)
            post '/users', params: {
              user: {
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                role_id: role.id
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            role = FactoryBot.create(:role)
            user = FactoryBot.build(:user)
            post '/users', params: {
              user: {
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                role_id: role.id
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end
        end
      end

      path '/users/accept_invite' do
        post 'Accept user invitation' do
          tags 'User'
          consumes 'application/json'
          parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/accept_invitation_request' }

          response '200 ', 'Success' do
            it 'Should accept user successfully and set their password, status: 200' do
              user = FactoryBot.create(:user)
              token = SecureRandom.hex(12)
              p = PasswordResetToken.new(user:, token_hash: Digest::SHA256.hexdigest(token))
              p.save!
              post '/users/accept_invite', params: {
                user: {
                  invitation_token: token,
                  password: 'Pas$w0rd',
                  password_confirmation: 'Pas$w0rd'
                }
              }
              expect(response).to have_http_status(:ok)
              expect(response.content_type).to include('application/json')
              expect(response.parsed_body['message']).to eq(I18n.t('messages.invitation_accepted'))
              user = User.find_by(email: user.email)
              expect(user).not_to be_nil
              expect(PasswordResetToken.find_by(user_id: user.id)).to be_nil
            end
          end

          response '422', 'Failed (Invalid password, unmatching passwords, invalid token)' do
            it 'Fail due to password validatoins' do
              user = FactoryBot.create(:user)
              token = SecureRandom.hex(12)
              p = PasswordResetToken.new(user:, token_hash: Digest::SHA256.hexdigest(token))
              p.save!
              post '/users/accept_invite', params: {
                user: {
                  invitation_token: token,
                  password: 'Pas$w0rd',
                  password_confirmation: 'Invalid'
                }
              }
              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.content_type).to include('application/json')
              expect(response.parsed_body).to be_has_key('error')
              expect(response.parsed_body['error']['password_confirmation'].join).to include("doesn't match")
            end

            it 'Fail due to password validatoins' do
              user = FactoryBot.create(:user)
              token = SecureRandom.hex(12)
              p = PasswordResetToken.new(user:, token_hash: Digest::SHA256.hexdigest(token))
              p.save!
              post '/users/accept_invite', params: {
                user: {
                  invitation_token: token,
                  password: 'P',
                  password_confirmation: 'P'
                }
              }
              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.content_type).to include('application/json')
              expect(response.parsed_body).to be_has_key('error')
              expect(response.parsed_body['error']['password'].join).to include('too short')
            end
            it 'Fail due to invalid token' do
              user = FactoryBot.create(:user)
              token = SecureRandom.hex(12)
              p = PasswordResetToken.new(user:, token_hash: Digest::SHA256.hexdigest(token))
              p.save!
              post '/users/accept_invite', params: {
                user: {
                  invitation_token: 'Invalid',
                  password: 'Pas$w0rd',
                  password_confirmation: 'Pas$w0rd'
                }
              }
              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.content_type).to include('application/json')
              expect(response.parsed_body).to be_has_key('error')
              expect(response.parsed_body['error']).to include('Sorry the invitation token provided is incorrect')
            end
          end
        end
      end
    end
  end
end
