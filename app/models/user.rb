class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :vk_token, :fb_token, :gender, :country, :city
  # attr_accessible :title, :body

  has_many :relationships

  has_many :hookups, :through => :friendships,
         :conditions => "status = 'accepted'"

  has_many :requested_hookups,
         :through => :friendships,
         :source => :hookup,
         :conditions => "status = 'requested'"
  
  has_many :pending_hookups,
         :through => :friendships,
         :source => :hookup,
         :conditions => "status = 'pending'"

  def fb_client
     FbGraph::User.fetch(fbuid, :access_token => fb_token)
  end

  def vk_client
    VkontakteApi::Client.new(vk_token)
  end

  def vk_token
    self[:vk_token] || ""
  end

  def fb_token
    self[:fb_token] || ""
  end

  def name
    last_name + " " + first_name
  end

  def photo_from_url(url)
    self.photo = URI.parse(url)
    self.photo_file_name = "avatar.png"
    self.photo_content_type = "image/png"
  end

  def self.flirt(user, friend)
    unless user == friend or Friendship.exists?(user, friend)
      transaction do
        create(:user => user, :hookup => friend, :status => 'pending')
        create(:user => friend, :hookup => user, :status => 'requested')
      end
    end
  end

  def self.date(user, friend)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, friend, accepted_at)
      accept_one_side(friend, user, accepted_at)
    end
  end

  def self.accept_one_side(user, friend, accepted_at)
    request = find_by_user_id_and_hookup_id(user, friend)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end

end
