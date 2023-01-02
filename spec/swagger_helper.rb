require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Exams API',
        version: 'v1'
      },
      paths: {},
      components: {
        contentType: 'application/vnd.api+json',
        securitySchemes: {
          Bearer: {
            description: 'JWT key necessary to use API calls',
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        },
        schemas: {
          user_login_request: {
            type: 'object',
            properties: {
              user: {
                type: 'object',
                properties: {
                  email: { type: 'string' },
                  password: { type: 'string' }
                },
                required: %w[email password]
              }
            },
            required: %w[user]
          },
          create_user_request: {
            type: 'object',
            properties: {
              user: {
                type: 'object',
                properties: {
                  email: { type: 'string' },
                  first_name: { type: 'string' },
                  last_name: { type: 'string' },
                  role_id: { type: 'integer' }
                },
                required: %w[email first_name last_name role_id]
              }
            },
            required: %w[user]
          },
          accept_invitation_request: {
            type: 'object',
            properties: {
              user: {
                type: 'object',
                properties: {
                  password: { type: 'string' },
                  password_confirmation: { type: 'string' },
                  invitation_token: { type: 'string' }
                },
                required: %w[password password_confirmation invitation_token]
              }
            },
            required: %w[user]
          },
          create_school_request: {
            type: 'object',
            properties: {
              school: {
                type: 'object',
                properties: {
                  name: { type: 'string' },
                  district_id: { type: 'integer' },
                },
                required: %w[name district_id]
              }
            },
            required: %w[school]
          },
          create_student_request: {
            type: 'object',
            properties: {
              student: {
                type: 'object',
                properties: {
                  full_name: { type: 'string' },
                  email: { type: 'string' },
                  seat_number: { type: 'integer' },
                  branch_id: { type: 'integer' },
                  school_id: { type: 'integer' }
                },
                required: %w[full_name email seat_number branch_id school_id]
              }
            },
            required: %w[student]
          }
        }
      },
      servers: [
        {
          url: '{defaultHost}',
          variables: {
            defaultHost: {
              default: ENV.fetch('DEVELOPMENT_SERVER_URL')
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
