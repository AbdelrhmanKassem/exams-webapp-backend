class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { message: I18n.t('devise.confirmations.logged_in') },
      user: UserBlueprint.render_as_hash(resource)
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: I18n.t('devise.confirmations.logged_out')
      }, status: :ok
    else
      render json: {
        error: I18n.t('devise.failure.log_out')
      }, status: :unauthorized
    end
  end
end
