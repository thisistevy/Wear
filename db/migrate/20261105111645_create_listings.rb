class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.string :condition
      t.string :category
      t.string :gender
      t.string :listing_type
      t.string :status, default: "disponible"

      t.timestamps
    end
  end
end
