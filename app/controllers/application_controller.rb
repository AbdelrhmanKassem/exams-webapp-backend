class ApplicationController < ActionController::API
  include RackSessionFix
  include Pundit::Authorization
  include ActionController::MimeResponds

  respond_to :json
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  private

  def unauthorized
    render json: { error: I18n.t('errors.authorization') }, status: :unauthorized
  end
end
