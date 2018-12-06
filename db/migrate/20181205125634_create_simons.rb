class CreateSimons < ActiveRecord::Migration[5.2]
  def change
    create_table :simons do |t|
      t.integer :request
      t.string :message
      t.string :data

      t.timestamps
    end

    add_index :simons, :request, unique: true
  end
end
