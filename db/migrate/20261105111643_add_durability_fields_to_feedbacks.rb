class AddDurabilityFieldsToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :rating, :integer
    add_column :feedbacks, :wash_resistance, :integer
    add_column :feedbacks, :wear_over_time, :integer
  end
end
