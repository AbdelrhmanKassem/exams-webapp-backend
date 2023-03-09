# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'students', type: :request do
  describe 'Student Api' do
    path '/students' do
      post 'Create Student' do
        security [Bearer: []]
        tags 'Student'
        consumes 'application/json'
        parameter name: :student, in: :body, schema: { '$ref' => '#/components/schemas/create_student_request' }

        response '201 ', 'Success' do
          it 'Should create student successfully and return created student object, status: 201' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            branch = FactoryBot.create(:branch)
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch_id: branch.id,
                school_id: school.id
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('student')
            student = Student.find(response.parsed_body['seat_number'])
            expect(student).not_to be_nil
          end
        end

        response '422', 'Failed (invalid student data)' do
          it 'Fail due to student model validatoins' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            branch = FactoryBot.create(:branch)

            id = school.id
            school.destroy!
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch_id: branch.id,
                school_id: id
              }
            }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to be_has_key('school')
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            branch = FactoryBot.create(:branch)
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch_id: branch.id,
                school_id: school.id
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            school = FactoryBot.create(:school)
            branch = FactoryBot.create(:branch)
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch_id: branch.id,
                school_id: school.id
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('devise.failure.unauthenticated'))
          end
        end
      end

      get 'Get Students' do
        security [Bearer: []]
        tags 'Student'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of students' do
          let(:page) { 1 }
          it 'Should respond with a page of students in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            FactoryBot.create_list(:student, 15, school_id: school.id)
            get '/students', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('student_index')
            expect(response.parsed_body['students'].length).to eq([Kaminari.config.default_per_page, Student.all.count].min)
          end
        end

        response '401', 'Failed (No auth header or not an admin)' do
          let(:page) { 1 }
          it 'Fail due to unauthorized user (not an admin)' do
            not_admin = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            get '/students', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/students', headers: headers
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
