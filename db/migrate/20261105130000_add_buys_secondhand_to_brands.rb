class AddBuysSecondhandToBrands < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :buys_secondhand, :boolean, default: false, null: false
  end
end
