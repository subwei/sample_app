class Micropost < ActiveRecord::Base
  belongs_to :user
  # Causes the returned microposts to be in descending order.
  # All scopes take an anonymous function that returns scope criteria.
  # This proc causes the given function to be called when needed (lazy eval)
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }  
  validates :user_id, presence: true	

  #def self.from_users_followed_by(user)
  	# Rails convention based on the has_many association. Same as:
  	# User.first.followed_users.map(&:id)
  	# This is bad because it reads all the followers ids into memory and
  	# creates a large array. A better solution is to push this computation
  	# to the database (inclusion in set).
    
    #followed_user_ids = user.followed_user_ids
    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  #end  

  # Returns microposts from the users being followed by the given user.
  # For more scaling than this, one solution is to generate the feed
  # asynchronously using a background job.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end  
end
