class AuthenticatedController < ApplicationController

  before_action :authenticate_request

  private

  def authenticate_request
    render json: { error: I18n.t('devise.failure.unauthenticated') }, status: :unauthorized unless current_user
  end
end
