class DistrictsController < AuthenticatedController

  include Sift

  filter_on :id, type: :int
  filter_on :name, internal_name: :search_by_name, type: :scope
  filter_on :governorate, type: :string


  sort_on :id, type: :int
  sort_on :name, type: :string
  sort_on :governorate, type: :string
  sort_on :school_count, internal_name: :order_on_school_count, type: :scope, scope_params: [:direction]

  def index
    authorize District
    districts = filtrate(District.all).page params[:page]
    render json: {
      districts: DistrictBlueprint.render_as_hash(districts, view: :index),
      meta: PaginationBlueprint.render(districts)
    }, status: :ok
  end

  def create
    authorize District
    district = District.new(district_params)

    if district.save
      render json: DistrictBlueprint.render(district), status: :created
    else
      render json: { error: district.errors.messages }, status: :unprocessable_entity
    end
  end

  def list
    authorize District
    render json: {
      districts: DistrictBlueprint.render_as_hash(District.all, view: :list),
    }, status: :ok
  end

  def destroy
    authorize District
    district = District.find_by(id: params[:id])
    if district.nil?
      render json: { error: I18n.t('messages.district.not_found') }, status: :not_found
      return
    end
    if district.destroy
      render json: {}, status: :ok
    else
      render json: { error: district.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def district_params
    params.require(:district).permit(:name, :governorate)
  end
end
