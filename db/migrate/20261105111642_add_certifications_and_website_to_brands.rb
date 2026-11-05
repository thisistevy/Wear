class AddCertificationsAndWebsiteToBrands < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :certifications, :string, array: true, default: []
    add_column :brands, :website, :string
  end
end
