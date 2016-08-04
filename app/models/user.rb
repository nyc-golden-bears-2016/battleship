class User < ApplicationRecord
  has_secure_password

  has_many :games, foreign_key: :player_1_id
  has_many :games, foreign_key: :player_2_id

  validates :username, :password, presence: true
  validates :username, uniqueness: true
end
