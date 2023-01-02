class StudentsController < AuthenticatedController

  def create
    authorize Student
    student = Student.new(student_params)

    if student.save
      render json: StudentBlueprint.render(student), status: :created
    else
      render json: { error: student.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def student_params
    params.require(:student).permit(:full_name, :email, :seat_number, :branch_id, :school_id)
  end
end
