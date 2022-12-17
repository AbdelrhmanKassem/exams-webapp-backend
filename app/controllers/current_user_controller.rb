class CurrentUserController < AuthenticatedController
  def index
    render json: UserBlueprint.render(current_user)
  end
end
