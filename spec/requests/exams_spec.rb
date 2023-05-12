# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'devise/jwt/test_helpers'


RSpec.describe 'exams', type: :request do
  describe 'Exams Api' do
    path '/exams' do
      post 'Create Exam' do
        security [Bearer: []]
        tags 'Exam'
        consumes 'application/json'
        parameter name: :exam, in: :body, schema: { '$ref' => '#/components/schemas/create_exam_request' }

        response '201 ', 'Success' do
          it 'Should create exam successfully and return created exam object, status: 201' do
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            headers = { Authorization: token }
            branch = FactoryBot.create(:branch)
            exam = FactoryBot.build(:exam)
            post '/exams', params: {
              exam: {
                name: exam.name,
                max_grade: exam.max_grade,
                start_time: exam.start_time,
                end_time: exam.end_time,
                branches: [branch.id],
                questions: [{'question':'Qes1','choices':['c1','c2','c3','c4']},
                            {'question':'ques2','choices':['c1','c2','c3','c444']},
                            {'question':'ques3','choices':['c1','c2','c3','c4','c5555','c6']}],
                answers: [1,2,3]
              }
            }, headers: headers
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('exam')
            exam = Exam.find(response.parsed_body['id'])
            expect(exam).not_to be_nil
          end
        end

        response '422', 'Failed (invalid exam data)' do
          it 'Fail due to exam model validatoins' do
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            headers = { Authorization: token }
            branch = FactoryBot.create(:branch)
            exam = FactoryBot.build(:exam)
            post '/exams', params: {
              exam: {
                max_grade: exam.max_grade,
                branches: [branch.id],
                questions: exam.questions,
                answers: exam.answers
              }
            }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to be_has_key('start_time')
          end
        end

        response '401', 'Failed (No auth header or not an examiner)' do
          it 'Fail due to unauthorized user (not an admin)' do
            not_examiner = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', not_examiner)
            headers = { Authorization: token }
            branch = FactoryBot.create(:branch)
            exam = FactoryBot.build(:exam)
            post '/exams', params: {
              exam: {
                max_grade: exam.max_grade,
                start_time: exam.start_time,
                end_time: exam.end_time,
                branches: [branch.id],
                questions: exam.questions,
                answers: exam.answers
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end

          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            branch = FactoryBot.create(:branch)
            exam = FactoryBot.build(:exam)
            post '/exams', params: {
              exam: {
                max_grade: exam.max_grade,
                start_time: exam.start_time,
                end_time: exam.end_time,
                branches: [branch.id],
                questions: exam.questions,
                answers: exam.answers
              }
            }, headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end
        end
      end

      get 'Get Exams' do
        security [Bearer: []]
        tags 'Exam'
        parameter name: :page, in: :query, type: :integer
        response '200 ', 'Return page of exams' do
          let(:page) { 1 }
          it 'Should respond with a page of exams in the system and pagination metadata, status: 200' do
            admin = FactoryBot.create(:admin_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', admin)
            headers = { Authorization: token }
            FactoryBot.create_list(:exam, 15)
            get '/exams', headers: headers
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to include('application/json')
            expect(response).to match_response_schema('exam_index')
            expect(response.parsed_body['exams'].length).to eq([Kaminari.config.default_per_page, Exam.all.count].min)
          end
        end

        response '401', 'Failed (No auth header)' do
          let(:page) { 1 }
          it 'Fail due to invalid Auth header' do
            headers = { Authorization: 'Invalid' }
            get '/exams', headers: headers
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to include('application/json')
            expect(response.parsed_body).to be_has_key('error')
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
          end
        end
      end
    end
    path '/exams/{id}' do
      get 'Show Exam' do
        security [Bearer: []]
        tags 'Exam'
        parameter name: :id, in: :path, type: :string
        produces 'application/json'
        response '200', 'Get Exam successfully' do
          it 'Should return exam object' do
            exam = FactoryBot.create(:exam)
            examiner = exam.examiner
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            get "/exams/#{exam.id}", headers: { Authorization: token }
            expect(response).to have_http_status(:ok)
            expect(response).to match_response_schema('exam')
            expect(response.content_type).to include('application/json')
          end
        end
        response '404', 'Exam not found' do
          it 'Should fail to get exam and return empty object' do
            exam = FactoryBot.create(:exam)
            examiner = exam.examiner
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            get '/exams/-1', headers: { Authorization: token }
            expect(response).to have_http_status(:not_found)
            expect(response.content_type).to include('application/json')
          end
        end
        response '401', 'Unauthorized user' do
          it 'Should return unauthorized message when user is unauthorized, status: 401' do
            exam = FactoryBot.create(:exam)
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            get "/exams/#{exam.id}", headers: { Authorization: token }
            expect(response).to have_http_status(:unauthorized)
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
            expect(response.content_type).to include('application/json')
          end
        end
      end

      put 'Update exam' do
        security [Bearer: []]
        tags 'Exam'
        consumes 'application/json'
        parameter name: :request_body, in: :body, schema: { '$ref' => '#/components/schemas/create_exam_request' }
        parameter name: :id, in: :path
        response '200', 'Update exam successfully' do
          it 'Update exam successfully and return success message' do
            exam = FactoryBot.create(:exam)
            examiner = exam.examiner
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            put "/exams/#{exam.id}",
                params:
                {
                  exam: {
                    max_grade: 100
                  }
                },
                headers: { Authorization: token }
            expect(response).to have_http_status(:ok)
            expect(response).to match_response_schema('exam')
            expect(response.parsed_body['max_grade']).to eq('100.0')
            expect(response.content_type).to include('application/json')
          end
        end
        response '404', 'Inexistent exam with specified ID' do
          it 'Fail to find exam and return error message, status: 404' do
            exam = FactoryBot.create(:exam)
            examiner = exam.examiner
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            put "/exams/#{exam.id + 1}",
                params:
                {
                  exam: {
                    max_grade: 100
                  }
                },
                headers: { Authorization: token }
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body['error']).to eq(I18n.t('messages.exam.not_found'))
            expect(response.content_type).to include('application/json')
          end
        end
        response '401', 'Unauthorized user' do
          it 'Should return unauthorized message when user is unauthorized, status: 401' do
            exam = FactoryBot.create(:exam)
            examiner = FactoryBot.create(:examiner_user)
            token = Devise::JWT::TestHelpers.auth_headers('Authorization', examiner)
            put "/exams/#{exam.id}",
            params: {
              exam: {
                max_grade: exam.max_grade,
                start_time: exam.start_time,
                end_time: exam.end_time,
                questions: exam.questions,
                answers: exam.answers
              }
            },
            headers: { Authorization: token }
            expect(response).to have_http_status(:unauthorized)
            expect(response.parsed_body['error']).to eq(I18n.t('errors.authorization'))
            expect(response.content_type).to include('application/json')
          end
        end
      end
    end
  end
end
