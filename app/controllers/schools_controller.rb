class SchoolsController < AuthenticatedController

  include Sift

  filter_on :id, type: :int
  filter_on :name, internal_name: :search_by_name, type: :scope
  filter_on :district_name, type: :scope
  filter_on :governorate, type: :scope

  sort_on :id, type: :int
  sort_on :name, type: :string
  sort_on :district_name, internal_name: :order_on_district_name, type: :scope, scope_params: [:direction]
  sort_on :governorate, internal_name: :order_on_governorate, type: :scope, scope_params: [:direction]
  sort_on :student_count, internal_name: :order_on_student_count, type: :scope, scope_params: [:direction]

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

  def destroy
    authorize School
    school = School.find_by(id: params[:id])
    if school.nil?
      render json: { error: I18n.t('messages.school.not_found') }, status: :not_found
      return
    end
    if school.destroy
      render json: {}, status: :ok
    else
      render json: { error: school.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :district_id)
  end
end
