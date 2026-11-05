class AddImportFieldsToCollectionPoints < ActiveRecord::Migration[6.0]
  def change
    # Identifier from the upstream open-data source, so re-running an import
    # updates the existing row instead of creating duplicates.
    add_column :collection_points, :source, :string
    add_column :collection_points, :external_id, :string
    # What you can do with your clothes there. Drives the map filters, while
    # point_type keeps driving the marker colour — a single place can be both
    # a drop-off and a resale point.
    add_column :collection_points, :categories, :string, array: true, default: []
    add_column :collection_points, :website, :string

    add_index :collection_points, %i[source external_id], unique: true
  end
end
