class BrandsController < ApplicationController
  def index
    @brands = Brand.all.order(:name)
    if params[:brands_filter].present? && params[:brands_filter][:certification].present?
      @brands = @brands.where("? = ANY (certifications)", params[:brands_filter][:certification])
    end
    @certifications = Brand.all.flat_map(&:certifications).uniq.sort
  end

  def show
    @brand = Brand.find(params[:id])
    @products = @brand.products
  end
end
