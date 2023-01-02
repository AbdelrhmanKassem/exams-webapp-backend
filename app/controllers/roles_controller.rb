class RolesController < AuthenticatedController
  def index
    authorize Role
    roles = Role.all.page params[:page]
    render json: {
      roles: RoleBlueprint.render_as_hash(roles),
      meta: PaginationBlueprint.render(roles)
    }, status: :ok
  end
end
