class MapsController < ApplicationController
  def index
    @brands = Brand.geocoded
    @collection_points = CollectionPoint.geocoded

    brand_markers = @brands.map do |brand|
      {
        lat: brand.latitude,
        lng: brand.longitude,
        type: "boutique",
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
