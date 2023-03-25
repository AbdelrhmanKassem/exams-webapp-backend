class StudentsController < AuthenticatedController

  include Sift

  filter_on :seat_number, type: :int
  filter_on :full_name, type: :string
  filter_on :school_id, type: :int
  filter_on :branch_id, type: :int

  filter_on :school_name, type: :scope
  filter_on :district_id, type: :scope
  filter_on :branch_name, type: :scope

  sort_on :seat_number, type: :int
  sort_on :school_id, type: :int
  sort_on :branch_id, type: :int


  def create
    authorize Student
    student = Student.new(student_params)

    if student.save
      render json: StudentBlueprint.render(student), status: :created
    else
      render json: { error: student.errors.messages }, status: :unprocessable_entity
    end
  end

  def index
    authorize Student
    students = filtrate(Student.all).page params[:page]
    render json: {
      students: StudentBlueprint.render_as_hash(students),
      meta: PaginationBlueprint.render(students)
    }, status: :ok
  end

  private

  def student_params
    params.require(:student).permit(:full_name, :email, :seat_number, :branch_id, :school_id)
  end
end
