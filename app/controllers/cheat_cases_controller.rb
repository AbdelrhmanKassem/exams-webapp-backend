class CheatCasesController < AuthenticatedController

  include Sift

  filter_on :student_seat_number, type: :int
  filter_on :exam_id, type: :int
  filter_on :proctor_id, type: :int

  sort_on :student_seat_number, type: :int
  sort_on :exam_name, internal_name: :order_on_exam_name, type: :scope, scope_params: [:direction]
  sort_on :proctor_name, internal_name: :order_on_proctor_name, type: :scope, scope_params: [:direction]

  def index
    authorize CheatCase
    cheat_cases = filtrate(CheatCase.all).page params[:page]
    render json: {
      cheat_cases: CheatCaseBlueprint.render_as_hash(cheat_cases),
      meta: PaginationBlueprint.render(cheat_cases)
    }, status: :ok
  end

  def create
    authorize CheatCase
    cheat_case = CheatCase.new(cheat_case_params)
    cheat_case.proctor = current_user
    if cheat_case.save
      render json: { cheat_case: CheatCaseBlueprint.render_as_hash(cheat_case) }, status: :created
    else
      render json: { error: cheat_case.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def cheat_case_params
    params.require(:cheat_case).permit(:student_seat_number, :exam_id, :notes)
  end
end
