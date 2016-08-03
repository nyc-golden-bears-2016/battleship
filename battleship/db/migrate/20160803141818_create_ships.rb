class CreateShips < ActiveRecord::Migration[5.0]
  def change
    create_table :ships do |t|
      t.string :type
      t.integer :length
      t.integer :game_id, foreign_key: true

      t.timestamps
    end
  end
end
