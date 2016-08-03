class CreateTiles < ActiveRecord::Migration[5.0]
  def change
    create_table :tiles do |t|
      t.string :coordinates
      t.boolean :hit, default: false
      t.integer :ship_id, foreign_key: true
      t.integer :game_id, foreign_key: true
      t.integer :player_id, foreign_key: true

      t.timestamps
    end
  end
end
