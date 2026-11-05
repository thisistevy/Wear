class ChangeListingsStatusDefaultToEnglish < ActiveRecord::Migration[6.0]
  def change
    change_column_default :listings, :status, from: "disponible", to: "available"
  end
end
