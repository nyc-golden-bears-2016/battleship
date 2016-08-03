class Tile < ApplicationRecord
  belongs_to :game
  belongs_to :ship, required: false
  belongs_to :player, class_name: 'User'

  validates :player, :game, presence: true

end
