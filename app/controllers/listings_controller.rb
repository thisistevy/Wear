class ListingsController < ApplicationController
  before_action :set_listing, only: %i[show edit update destroy]
  before_action :ensure_owner, only: %i[edit update destroy]

  def index
    if params[:mine].present?
      @listings = current_user.listings.order(created_at: :desc)
      return
    end

    @listings = Listing.available.order(created_at: :desc)

    if params[:listings_filter].present?
      if params[:listings_filter][:category].present?
        @listings = @listings.where(category: params[:listings_filter][:category])
      end

      if params[:listings_filter][:listing_type].present?
        @listings = @listings.where(listing_type: params[:listings_filter][:listing_type])
      end
    end
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    if @listing.save
      redirect_to listing_path(@listing)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to listing_path(@listing)
    else
      render :edit
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_path
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def ensure_owner
    redirect_to listings_path unless @listing.user == current_user
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :condition, :category, :gender, :listing_type, :status, :picture)
  end
end
