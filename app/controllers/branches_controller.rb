class BranchesController < AuthenticatedController
  def index
    authorize Branch
    branches = Branch.all.page params[:page]
    render json: {
      branches: BranchBlueprint.render_as_hash(branches),
      meta: PaginationBlueprint.render(branches)
    }, status: :ok
  end
end
