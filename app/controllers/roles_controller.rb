class RolesController < AuthenticatedController

  include Sift

  filter_on :id, type: :int
  filter_on :name, internal_name: :search_by_name, type: :scope

  sort_on :id, type: :int
  sort_on :name, type: :string
  sort_on :user_count, internal_name: :order_on_user_count, type: :scope, scope_params: [:direction]

  def index
    authorize Role
    roles = filtrate(Role.all).page params[:page]
    render json: {
      roles: RoleBlueprint.render_as_hash(roles, view: :index),
      meta: PaginationBlueprint.render(roles)
    }, status: :ok
  end
end
