class SchoolsController < AuthenticatedController

  def create
    authorize School
    school = School.new(school_params)

    if school.save
      render json: SchoolBlueprint.render(school), status: :created
    else
      render json: { error: school.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :district_id)
  end
end
