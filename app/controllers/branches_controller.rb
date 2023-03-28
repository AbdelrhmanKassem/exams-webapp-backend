class BranchesController < AuthenticatedController


  include Sift

  filter_on :id, type: :int
  filter_on :name, type: :string


  sort_on :id, type: :int
  sort_on :name, type: :string

  def index
    authorize Branch
    branches = filtrate(Branch.all).page params[:page]
    render json: {
      branches: BranchBlueprint.render_as_hash(branches),
      meta: PaginationBlueprint.render(branches)
    }, status: :ok
  end
end
