class UserMailer < ApplicationMailer
  def user_invite_email(user, token)
    @resource = user
    @token = token
    mail(to: user.email, subject: I18n.t('mailers.subject.invitation'))
  end
end
