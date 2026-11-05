class MapsController < ApplicationController
  # The map is the root page, so it has to be reachable logged out — otherwise
  # every visitor lands on the sign-in screen instead of the app itself.
  skip_before_action :authenticate_user!

  def index
    @brands = Brand.geocoded
    @collection_points = CollectionPoint.geocoded

    brand_markers = @brands.map do |brand|
      {
        lat: brand.latitude,
        lng: brand.longitude,
        type: "store",
        info_window: render_to_string(partial: "brand_info_window", locals: { brand: brand }),
      }
    end

    collection_point_markers = @collection_points.map do |point|
      {
        lat: point.latitude,
        lng: point.longitude,
        type: point.point_type,
        info_window: render_to_string(partial: "collection_point_info_window", locals: { point: point }),
      }
    end

    @markers = brand_markers + collection_point_markers
  end
end
