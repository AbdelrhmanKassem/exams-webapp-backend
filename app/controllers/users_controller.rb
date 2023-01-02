class UsersController < AuthenticatedController

  def create
    authorize User
    user = User.new(user_params)
    if user.save
      token = SecureRandom.hex(12)
      p = PasswordResetToken.new(user:, token_hash: Digest::SHA256.hexdigest(token))
      if p.save
        UserMailer.user_invite_email(user, token).deliver
        render json: { message: I18n.t('messages.success', operation: 'user created') }, status: :created
      end
    else
      render json: { error: user.errors.messages }, status: :unprocessable_entity
    end
  end

  def accept_invite
    token_hash = Digest::SHA256.hexdigest(accept_invite_params[:invitation_token])
    p = PasswordResetToken.find_by(token_hash:)

    unless p.present?
      render json: { error: I18n.t('errors.invalid_invitation') }, status: :unprocessable_entity
      return
    end

    user = p.user
    user.password = accept_invite_params[:password]
    user.password_confirmation = accept_invite_params[:password_confirmation]
    if user.save
      PasswordResetToken.delete(user.id)
      render json: { message: I18n.t('messages.invitation_accepted') }, status: :ok
    else
      render json: { error: user.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :email)
  end

  def accept_invite_params
    params.require(:user).permit(:invitation_token, :password, :password_confirmation)
  end
end
