class Game < ApplicationRecord
  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User', required: false
  has_many :ships
  has_many :tiles


  def create_tiles
    rows = %w(a b c d e f g h i j)
    cols = %w(1 2 3 4 5 6 7 8 9 10)
    rows.each do |letter|
      cols.each do |number|
        coord = letter + ", " + number
        Tile.create(coordinates: coord, game_id: self.id, player_id: self.player_1)
        # Tile.create(corod: coord, game_id: self.id, player_id: self.player_2)
      end
    end
  end

  def self.create_opponent_tiles
    rows = %w(a b c d e f g h i j)
    cols = %w(1 2 3 4 5 6 7 8 9 10)
    # current game method
    game = Game.find(User.first.id)
    opp = opponent(game.id)
    rows.each do |letter|
      cols.each do |number|
        coord = letter + ", " + number
        Tile.create!(coordinates: coord, game_id: game.id, player_id: opp.id)
      end
    end
  end


end
