class Ship < ApplicationRecord
  has_many :tiles
  belongs_to :game
end
