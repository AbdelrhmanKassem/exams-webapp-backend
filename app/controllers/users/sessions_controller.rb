class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if current_user
      render json: {
        status: { message: 'Logged in sucessfully.' },
        user: UserBlueprint.render_as_hash(resource)
      }, status: :ok
    else
      render json: {
        status: { message: 'Invalid Credentials.' }
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: 'Logged out successfully'
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
