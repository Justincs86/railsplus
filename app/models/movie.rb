class Movie < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :reviews
  has_many :movie_relationships
  has_many :favorites, through: :movie_relationships, source: :user
end
