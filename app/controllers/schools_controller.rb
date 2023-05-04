class SchoolsController < AuthenticatedController

  include Sift

  filter_on :id, type: :int
  filter_on :name, type: :string
  filter_on :district_name, type: :scope
  filter_on :governorate, type: :scope

  sort_on :id, type: :int
  sort_on :name, type: :string
  sort_on :district_id, type: :int

  def index
    authorize School
    schools = filtrate(School.all).page params[:page]
    render json: {
      schools: SchoolBlueprint.render_as_hash(schools, view: :index),
      meta: PaginationBlueprint.render(schools)
    }, status: :ok
  end

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
