class BranchesController < AuthenticatedController


  include Sift

  filter_on :id, type: :int
  filter_on :name, internal_name: :search_by_name, type: :scope


  sort_on :id, type: :int
  sort_on :name, type: :string
  sort_on :student_count, internal_name: :order_on_student_count, type: :scope, scope_params: [:direction]
  sort_on :exam_count, internal_name: :order_on_exam_count, type: :scope, scope_params: [:direction]


  def index
    authorize Branch
    branches = filtrate(Branch.all).page params[:page]
    render json: {
      branches: BranchBlueprint.render_as_hash(branches, view: :index),
      meta: PaginationBlueprint.render(branches)
    }, status: :ok
  end
end
