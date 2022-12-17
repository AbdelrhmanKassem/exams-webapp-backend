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
            admin = FactoryBot.build(:user)
            admin.role = 'admin'
            admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                username: student.username,
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch: student.branch,
                school_id: school.id
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('student')
            student = Student.find_by(id: response.parsed_body['id'])
            expect(student).not_to be_nil
          end
        end

        response '422', 'Failed (invalid student data)' do
          it 'Fail due to student model validatoins' do
            admin = FactoryBot.build(:user)
            admin.role = 'admin'
            admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            id = school.id
            school.destroy!
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                username: student.username,
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch: student.branch,
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
            not_admin = FactoryBot.build(:user)
            not_admin.role = 'examiner'
            not_admin.save!
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_admin)
            headers = { Authorization: token }
            school = FactoryBot.create(:school)
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                username: student.username,
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch: student.branch,
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
            student = FactoryBot.build(:student)
            post '/students', params: {
              student: {
                username: student.username,
                full_name: student.full_name,
                email: student.email,
                seat_number: student.seat_number,
                branch: student.branch,
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
    end
  end
end
