class AddPlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.text :note
      t.string :destination_reference
      t.text :destination
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
