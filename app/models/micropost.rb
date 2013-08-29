class Micropost < ActiveRecord::Base
  belongs_to :user
  # Causes the returned microposts to be in descending order.
  # All scopes take an anonymous function that returns scope criteria.
  # This proc causes the given function to be called when needed (lazy eval)
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }  
  validates :user_id, presence: true	
end
