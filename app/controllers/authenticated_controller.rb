class AuthenticatedController < ApplicationController

  before_action :authenticate_request, except: %i[accept_invite]

  private

  def authenticate_request
    render json: { error: I18n.t('devise.failure.unauthenticated') }, status: :unauthorized unless current_user
  end
end
