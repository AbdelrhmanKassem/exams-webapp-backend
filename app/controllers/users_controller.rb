class UsersController < AuthenticatedController

  def create
    authorize User
    user = User.new(user_params)
    if user.save
      user.invite!
      render json: { message: I18n.t('messages.success', operation: 'user created') }, status: :created
    else
      render json: { error: user.errors.messages }, status: :unprocessable_entity
    end
  end

  def accept_invite
    user = User.accept_invitation!(invite_params)
    if user.id.present? && user.valid?
      render json: { message: I18n.t('messages.invitation_accepted') }, status: :ok
    else
      render json: { error: user.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :email, :username)
  end

  def invite_params
    params.require(:user).permit(:invitation_token, :password, :password_confirmation)
  end
end
