class Tile < ApplicationRecord
  belongs_to :game
  belongs_to :ship
  belongs_to :player
end
