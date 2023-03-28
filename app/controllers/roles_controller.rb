class RolesController < AuthenticatedController

  include Sift

  filter_on :id, type: :int
  filter_on :name, type: :string

  sort_on :id, type: :int
  sort_on :name, type: :string

  def index
    authorize Role
    roles = filtrate(Role.all).page params[:page]
    render json: {
      roles: RoleBlueprint.render_as_hash(roles),
      meta: PaginationBlueprint.render(roles)
    }, status: :ok
  end
end
