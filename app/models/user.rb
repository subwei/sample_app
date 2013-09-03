class User < ActiveRecord::Base
  # dependent: destroy causes the microposts to be deleted when the associated
  # user is deleted.
  # Rails infers association of foreign key to be <lower case class>_id.  
	has_many :microposts, dependent: :destroy
  # Unlike microposts, we need to tell Rails what foreign key to use.
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy  

  # By default, the has_many through association Rails expects the foreign key
  # to be the singular version of the association.
  # has_many :followeds, through: :relationships
  # But we want to override the method name and inform Rails that the
  # followed_users array is the set of followed ids.
  has_many :followed_users, through: :relationships, source: :followed

  # We need to specify the class_name otherwise rails will look for the
  # ReverseRelationship class.
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower


  before_save { self.email = email.downcase }
	before_create :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    # The ? ensures that id is properly escaped before including it in the sql
    # query.
    # Micropost.where("user_id = ?", id)

    # For full featured feed.
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    # Left out the self.  
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    # Left out the self.      
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end  

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end