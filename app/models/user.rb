class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :token_authenticatable, :omniauthable
         #:validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :vk_token, :fb_token, :gender, :country, :city
  attr_accessible :vkuid, :birthday, :provider, :photo_url, :provider, :is_active, :city_id, :country_id

  has_many :relationships

  has_many :hookups, :through => :relationships,
         :conditions => "status = 'accepted'"

  has_many :requested_hookups,
         :through => :relationships,
         :source => :hookup,
         :conditions => "status = 'requested'"
  
  has_many :pending_hookups,
         :through => :relationships,
         :source => :hookup,
         :conditions => "status = 'pending'"

  
  LOOKING_FOR_MALE = 0
  LOOKING_FOR_FEMALE = 1
  LOOKING_FOR_BOTH = 2

  USER_MALE = false
  USER_FEMALE = true

  VK_USER_SEX_MALE = 2
  VK_USER_SEX_FEMALE = 1
  VK_USER_SEX_UNKNOWN = 0

  STATUS_TYPES = {accepted: 1, requested: 2, pending: 3, rejected: 4}

  serialize :friends_list

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

  def email
     self[:email] || ""
  end

  def looking_for_gender
    self[:looking_for_gender] || 0
  end

  def location 
    self[:location] || ""
  end

  def self.guess_looking_for(gender)
    if gender == USER_MALE
      LOOKING_FOR_FEMALE
    else
      LOOKING_FOR_MALE
    end
  end

  def guess_looking_for(gender)
    User.guess_looking_for(gender)
  end

  def gender_for_vk_gender(vk_gender)
    User.gender_for_vk_gender(vk_gender)
  end

  def self.gender_for_vk_gender(vk_gender)
    if vk_gender == VK_USER_SEX_MALE
      USER_MALE
    elsif vk_gender == VK_USER_SEX_FEMALE
      USER_FEMALE
    else
      USER_FEMALE
    end
  end

  def get_friends
    fields = [:first_name, :last_name, :screen_name, :sex, :bdate, :city, :country, :photo_big]
    self.friends_list = vk_client.friends.get
    vk_client.friends.get(fields: fields) do |friend|
      puts "#{friend.first_name} '#{friend.screen_name}' #{friend.last_name}"
      puts friend.to_yaml
      user = User.where(:vkuid => friend.uid).first
      if user.blank?
        user = User.create!(
          :vkuid => friend.uid,
          :password => Devise.friendly_token[0,20],
          :first_name => friend.first_name,
          :last_name => friend.last_name,
          :birthday => friend.bdate,
          :city_id => friend.city,
          :country_id => friend.country,
          #:city => get_vk_city(friend.city, self.vk_token),
          #:country => get_vk_country(friend.country, self.vk_token),
          :gender => gender_for_vk_gender(friend.sex),
          :looking_for_gender => guess_looking_for(gender_for_vk_gender(friend.sex)),
          :provider => :vkontakte,
          :photo_url => friend.photo_big,
          :is_active => false)
      end
      # User.flirt(self, user)
      # break
    end
    save
  end

  #authentication

  def update_user_from_vk_graph(vk_user, access_token)
    self.vk_token = access_token
  end

  def self.create_user_from_vk_graph(vk_user, access_token)
    user = User.create(
          :vkuid => vk_user.uid,
          :password => Devise.friendly_token[0,20],
          :first_name => vk_user.first_name,
          :last_name => vk_user.last_name,
          :birthday => vk_user.bdate,
          :city => get_vk_city(vk_user.city, access_token),
          :country => get_vk_country(vk_user.country, access_token),
          :vk_token => access_token,
          :gender => gender_for_vk_gender(vk_user.sex),
          :looking_for_gender => guess_looking_for(gender_for_vk_gender(friend.sex)),
          :provider => :vkontakte,
          :photo_url => vk_user.photo_big,
          :is_active => true)
    # delay this
    user.find_friends
    user
  end

  def update_user_from_fb_graph(facebook_user)
    self.fb_token = facebook_user.access_token
    self.first_name = facebook_user.first_name
    self.last_name = facebook_user.last_name
    self.birthday = facebook_user.birthday
    self.location = facebook_user.location.name unless facebook_user.location.blank?
    self.gender = (facebook_user.gender == "male") ? USER_SEX_MALE : USER_SEX_FEMALE
    puts "https://graph.facebook.com/#{facebook_user.identifier}/picture?width=100&height=100"
    self.photo_url "https://graph.facebook.com/#{facebook_user.identifier}/picture?width=100&height=100"
    #photo_from_url "http://www.warrenphotographic.co.uk/photography/cats/21495.jpg"

    save
  end

  def self.create_user_from_fb_graph(facebook_user)
    user = User.create(:email => facebook_user.email,
          :fbuid => facebook_user.identifier,
          :password => Devise.friendly_token[0,20],
          :name => facebook_user.name,
          :first_name => facebook_user.first_name,
          :last_name => facebook_user.last_name,
          :birthday => facebook_user.birthday,
          :location => (facebook_user.location.blank?) ? "" : facebook_user.location.name,
          :fb_token => facebook_user.access_token,
          :provider => :facebook,
          :gender => (facebook_user.gender == "male") ? USER_SEX_MALE : USER_SEX_FEMALE)
    user.photo_from_url "https://graph.facebook.com/#{facebook_user.identifier}/picture?width=100&height=100"
    return user
  end

  def self.find_or_create_for_vkontakte_oauth(vk_user, access_token)
    logger.debug vk_user.to_yaml
    if user = User.where(:vkuid => vk_user.uid).first
      user.update_user_from_vk_graph(vk_user, access_token)
      # User was created before. Just return him
    elsif user = User.find_by_email(vk_user.email)
      # User was created by parsing email. Add missing attrbute.
      user.update_user_from_vk_graph(vk_user, access_token)
      #UserMailer.activation(user).deliver rescue nil
    else
      user = User.create_user_from_vk_graph(vk_user, access_token)
    end
    user
  end

  def self.find_or_create_for_facebook_oauth(facebook_user, signed_in_resource=nil)
    logger.debug facebook_user.to_yaml
    if user = User.where(:fbuid => facebook_user.identifier).first
      user.update_user_from_fb_graph(facebook_user)
      # User was created before. Just return him
    elsif user = User.find_by_email(facebook_user.email)
      # User was created by parsing email. Add missing attrbute.
      user.update_user_from_fb_graph(facebook_user)
      #UserMailer.activation(user).deliver rescue nil
    else
      user = User.create_user_from_fb_graph(facebook_user)
    end

    user
  end

  def possible_hookups
    User.where(:vkuid => self.friends_list)
  end

  def is_requested?(hookup)
    self.relationships.exists?(hookup_id: hookup.id, status: 'requested')
  end

  def self.flirt(user, friend)
    unless user == friend or user.relationships.exists?(hookup_id: friend.id)
      transaction do
        Relationship.create(:user => user, :hookup => friend, :status => 'pending')
        Relationship.create(:user => friend, :hookup => user, :status => 'requested')
      end
    end
  end

  def self.reject(user, friend)
     unless user == friend or user.relationships.exists?(hookup_id: friend.id)
      transaction do
        Relationship.create(:user => user, :hookup => friend, :status => 'rejected')
        Relationship.create(:user => friend, :hookup => user, :status => 'rejected')
      end
    end
  end

  def self.fuck(user, friend)
    transaction do
      accepted_at = Time.now
      User.accept_one_side(user, friend, accepted_at)
      User.accept_one_side(friend, user, accepted_at)
    end
  end

  def self.accept_one_side(user, friend, accepted_at)
    request = Relationship.find_by_user_id_and_hookup_id(user, friend)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end

   def self.get_vk_city(id, token)
    HTTParty.get('https://api.vk.com/method/getCities', {query: {cids: id, access_token: token}})["response"].first["name"]
  end

  def self.get_vk_country(id, token)
    HTTParty.get('https://api.vk.com/method/getCountries', {query: {cids: id, access_token: token}})["response"].first["name"]
  end

  private

  def get_vk_city(id, token)
    User.get_vk_city(id, token)
  end

  def get_vk_country(id, token)
    User.get_vk_country(id, token)
  end

end
