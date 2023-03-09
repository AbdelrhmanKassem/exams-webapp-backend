class DistrictsController < AuthenticatedController
  def index
    authorize District
    districts = District.all.page params[:page]
    render json: {
      districts: DistrictBlueprint.render_as_hash(districts),
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

  private

  def district_params
    params.require(:district).permit(:name, :governorate)
  end
end
