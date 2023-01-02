class DistrictsController < AuthenticatedController
  def index
    authorize District
    districts = District.all.page params[:page]
    render json: {
      districts: DistrictBlueprint.render_as_hash(districts),
      meta: PaginationBlueprint.render(districts)
    }, status: :ok
  end
end
