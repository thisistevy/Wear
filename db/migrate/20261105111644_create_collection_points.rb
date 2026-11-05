class CreateCollectionPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_points do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :point_type
      t.text :description
      t.references :brand, null: true, foreign_key: true

      t.timestamps
    end
  end
end
