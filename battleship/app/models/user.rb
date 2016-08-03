class User < ApplicationRecord
  has_many :games, foreign_key: :player_1_id
  has_many :games, foreign_key: :player_2_id
  has_secure_password
end
