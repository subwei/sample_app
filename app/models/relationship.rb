class Relationship < ActiveRecord::Base
  # Rails will infer the names of the foreign keys from the symbols.
  # :follower -> follower_id, :followed -> followed_id.
  # We need to specify the class "User" because there isn't a
  # Followed or Follower model.
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true  
end