class Tile < ApplicationRecord
  belongs_to :game
  belongs_to :ship
  belongs_to :player

  validates :player, :game, presence: true
end
