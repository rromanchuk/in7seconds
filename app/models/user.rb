# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :registerable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :token_authenticatable, :omniauthable, :confirmable
         #:validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :vk_token, :fb_token, :gender, :country, :city, :fbuid, :email_opt_in, :push_opt_in, :fb_domain, :status
  attr_accessible :vkuid, :birthday, :provider, :photo_url, :provider, :is_active, :looking_for_gender, :latitude, :longitude, :vk_city, :vk_country, :vk_domain, :vk_graduation, :vk_university_name, :vk_faculty_name, :vk_mobile_phone

  has_many :images
  has_many :relationships, :dependent => :destroy

  has_many :hookups, :through => :relationships,
         :conditions => "relationships.status = 'accepted'", 
         :select => 'users.*, relationships.updated_at as matched_at'

  has_many :requested_hookups,
         :through => :relationships,
         :source => :hookup,
         :conditions => "relationships.status = 'requested'"
  
  has_many :pending_hookups,
         :through => :relationships,
         :source => :hookup,
         :conditions => "relationships.status = 'pending'"

  has_many :rejected_hookups,
         :through => :relationships,
         :source => :hookup,
         :conditions => "relationships.status = 'rejected'"

  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :inverse_memberships, :class_name => "Membership", :foreign_key => "group_id"
  has_many :inverse_memberships, :through => :inverse_memberships, :source => :user
  

  has_many :messages_received,  :class_name => 'Message', :foreign_key => 'to_user_id'
  has_many :messages_sent,      :class_name => 'Message', :foreign_key => 'from_user_id'

  has_many :notifications, :class_name => 'Notification', :foreign_key => 'receiver_id'

  belongs_to :vk_country
  belongs_to :vk_city
  belongs_to :fb_location

  scope :active, -> { where(is_active: true) }
  scope :with_geo_location, -> { where('latitude IS NOT NULL') }
  scope :men, -> { where(gender: false) }
  scope :women, -> { where(gender: true) }
  
  LOOKING_FOR_MALE = 0
  LOOKING_FOR_FEMALE = 1
  LOOKING_FOR_BOTH = 2

  USER_MALE = false
  USER_FEMALE = true

  VK_USER_SEX_MALE = 2
  VK_USER_SEX_FEMALE = 1
  VK_USER_SEX_UNKNOWN = 0

  STATUS_TYPES = {accepted: 1, requested: 2, pending: 3, rejected: 4}


  reverse_geocoded_by :latitude, :longitude

  after_create :get_groups, :if => :is_active?
  after_create :get_friends, :if => :is_active?
  after_create :get_photos, :if => :is_active?
  
  after_create :welcome_email, :if => :is_active?
  before_destroy :remove_relationships
  
  #before_save :require_confirmation, :on => :create
  after_save :check_email_status
 
  VK_FIELDS = [:first_name, :last_name, :screen_name, :sex, :bdate, :city, :country, :photo_big, :graduation, :university_name, :education, :domain, :contacts]

  scope :added_yesterday, -> { where(created_at: Date.yesterday...Date.today, is_active: true) }

  #devise 
  # def require_confirmation
  #   self.skip_confirmation! unless (is_active? && !email.blank?)  
  # end

  def check_email_status
    if is_active? && has_facebook?
      #confirm!
    elsif is_active? && !email.blank?
      if confirmation_sent_at.blank? && !confirmed?
        send_confirmation_instructions
      end
    end
  end

   # Access token for a user
  def access_token
    User.create_access_token(self)
  end

  # Verifier based on our application secret
  def self.verifier
    ActiveSupport::MessageVerifier.new(In7seconds::Application.config.secret_token)
  end

  # Get a user from a token
  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find_by_id id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user)
    verifier.generate(user.id)
  end

  def remove_relationships
    Relationship.where(hookup_id: self.id).map(&:destroy)
  end

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

  def latitude
    self[:latitude] || 0
  end

  def longitude
    self[:longitude] || 0
  end

  def looking_for_gender
    self[:looking_for_gender] || 0
  end

  def location
    if fb_location
      fb_location.name
    else
      "#{city}, #{country}"
    end
  end
  
  def city
    if vk_city
      vk_city.name
    else
      ''
    end
  end

  def vk_domain
    self[:vk_domain] || ""
  end

  def vk_university_name
    self[:vk_university_name] || ""
  end

  def vk_faculty_name
    self[:vk_faculty_name] || ""
  end

  def birthday
    self[:birthday] || ""
  end

  def birthday_simple
    birthday.blank? ? "" : birthday.strftime('%Y-%m-%d') 
  end

  def country
    if vk_country
      vk_country.name
    else
      ''
    end
  end

  def messages
    messages_received + messages_sent
  end

  def can_crawl_vk?
    has_vkontakte? && is_active? && !vk_token_expired?
  end

  def fb_token_expired?
    if fb_token_expiration
      fb_token_expiration < Time.now
    else
      true
    end
  end

  def vk_token_expired?
    # if vk_token_expiration
    #   vk_token_expiration < Time.now
    # else
    #   true
    # end
    false
  end

  def has_facebook?
    fb_token?
  end

  def has_vkontakte?
    vk_token?
  end

  def mutual_group_names(hookup)
    mutual_groups(hookup).map(&:name).join(', ')
  end

  def mutual_friend_names(hookup)
    mutual_friends(hookup).map(&:name).join(', ')
  end

  def group_names
    groups.map(&:name).join(', ')
  end

  def friend_names
    friends.map(&:name).join(', ')
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

  def is_girl?
    gender == USER_FEMALE
  end

  def vk_app_users
    User.where(vkuid: vk_client.friends.getAppUsers)
  end

  def mutual_friends(hookup)
    Rails.cache.fetch("#{self.cache_key}_mutual_friends") do
      self.friends & hookup.friends
    end
  end

  def mutual_friends_num(hookup)
    mutual_friends(hookup).length
  end

  def mutual_groups(hookup)
    Membership.includes([:group]).where('group_id IN (?)', self.groups.map(&:id) ).where(user_id: hookup.id).map(&:group)
  end

  def all_threads
    threads = []
    hookups.each do |hookup|
      thread = Message.thread(self, hookup)
      threads << thread unless thread.blank?
    end
    threads
  end

  def all_messages
    Message.where('(from_user_id = ?) OR (to_user_id = ?)', self.id, self.id)
  end

  # after create callbacks
  def welcome_email
    Mailer.delay({:run_at => 5.minutes.from_now}).welcome(self) unless self.email.blank?
  end

  def get_groups
    if can_crawl_vk?
      vk_client.getGroupsFull.each do |g|
        puts "adding #{g.name}"
        group = Group.where(gid: g.gid, provider: "vk").first_or_create
        group.update_attributes(name: g.name, photo: g.photo)
        self.groups << group unless self.groups.exists?(group)
      end
    end
  end
  handle_asynchronously :get_groups

  def get_photos
    if can_crawl_vk?
      vk_client.photos.getUserPhotos.each do |photo|
        if photo.is_a?(Hash)
          image = Image.where(external_id: photo.pid, provider: :vkontakte).first_or_create(remote_url: photo.src_big)
          self.images << image unless self.images.exists?(image)
        end
      end
    end
  end
  handle_asynchronously :get_photos

  def get_friends
    if can_crawl_vk?
      vk_client.friends.get(fields: VK_FIELDS, lang:"ru", uid: vkuid) do |friend|
        puts "#{friend.first_name} '#{friend.screen_name}' #{friend.last_name}"
        puts friend.to_yaml
        
        next unless User.photo_url_is_good?(friend.photo_big)

        user = User.where(vkuid: friend.uid).first_or_create(:password => Devise.friendly_token[0,20],
            :first_name => friend.first_name,
            :last_name => friend.last_name,
            :birthday => friend.bdate,
            :vk_city => VkCity.where(cid: friend.city).first_or_create,
            :vk_country => VkCountry.where(cid: friend.country).first_or_create,
            :gender => gender_for_vk_gender(friend.sex),
            :looking_for_gender => guess_looking_for(gender_for_vk_gender(friend.sex)),
            :provider => :vkontakte,
            :photo_url => friend.photo_big,
            :vk_domain => friend.domain, 
            :vk_graduation => friend.graduation,
            :vk_university_name => friend.university_name,
            :vk_faculty_name => friend.faculty_name,
            :vk_mobile_phone => friend.mobile_phone,
            :is_active => false)

        self.friends << user unless self.friends.exists?(user)
      end
      save
    end
  end
  handle_asynchronously :get_friends


  def self.photo_url_is_good?(photo_url)
    if photo_url =~ /camera_a|deactivated/
      false
    else
      true
    end
  end
  #authentication

  def update_user_from_vk_graph(vk_user, access_token)
    
    self.vk_token = access_token
    
    if self.is_active == false
      self.birthday = vk_user.bdate

      self.vk_city = VkCity.where(cid: vk_user.city).first_or_create
      self.vk_country = VkCountry.where(cid: vk_user.country).first_or_create
      self.is_active = true
      self.email = vk_user.email
      save
      welcome_email
      get_friends
      get_groups

    end
    save
  end

  def self.create_user_from_vk_graph(vk_user, access_token)
    user = User.create(
          :vkuid => vk_user.uid,
          :password => Devise.friendly_token[0,20],
          :first_name => vk_user.first_name,
          :last_name => vk_user.last_name,
          :birthday => vk_user.bdate,
          :vk_city => VkCity.where(cid: vk_user.city).first_or_create,
          :vk_country => VkCountry.where(cid: vk_user.country).first_or_create,
          :vk_token => access_token,
          :gender => gender_for_vk_gender(vk_user.sex),
          :looking_for_gender => guess_looking_for(gender_for_vk_gender(vk_user.sex)),
          :provider => :vkontakte,
          :photo_url => vk_user.photo_big,
          :vk_domain => vk_user.domain, 
          :vk_graduation => vk_user.graduation,
          :vk_university_name => vk_user.university_name,
          :vk_faculty_name => vk_user.faculty_name,
          :vk_mobile_phone => vk_user.mobile_phone,
          :is_active => true,
          :email => (vk_user.email.blank?) ? '' : vk_user.email)
    user
  end

  def update_user_from_fb_graph(facebook_user)
    self.fb_token = facebook_user.access_token
    self.first_name = facebook_user.first_name
    self.last_name = facebook_user.last_name
    self.birthday = facebook_user.birthday
    self.fb_domain = facebook_user.username
    self.fb_location = FbLocation.where(lid: facebook_user.location.identifier, name: facebook_user.location.name).first_or_create unless facebook_user.location.blank?
    self.gender = (facebook_user.gender == "male") ? USER_MALE : USER_FEMALE
    self.photo_url = "https://graph.facebook.com/#{facebook_user.identifier}/picture?width=640&height=640"
    self.is_active = true;
    save
  end

  def self.create_user_from_fb_graph(facebook_user)
    user = User.create(:email => facebook_user.email,
          :fbuid => facebook_user.identifier,
          :password => Devise.friendly_token[0,20],
          :first_name => facebook_user.first_name,
          :last_name => facebook_user.last_name,
          :fb_domain => facebook_user.username,
          :birthday => facebook_user.birthday,
          :looking_for_gender => guess_looking_for((facebook_user.gender == "male") ? USER_MALE : USER_FEMALE),
          :fb_token => facebook_user.access_token,
          :provider => :facebook,
          :is_active => true,
          :photo_url => "https://graph.facebook.com/#{facebook_user.identifier}/picture?width=640&height=640",
          :gender => (facebook_user.gender == "male") ? USER_MALE : USER_FEMALE)
    user.fb_location = FbLocation.where(lid: facebook_user.location.identifier, name: facebook_user.location.name).first_or_create unless facebook_user.location.blank?
    user.save
    return user
  end

  def self.find_or_create_for_vkontakte_oauth(vk_user, access_token)
    logger.debug vk_user.to_yaml
    if user = User.where(:vkuid => vk_user.uid).first
      user.update_user_from_vk_graph(vk_user, access_token)
      # User was created before. Just return him
    elsif !vk_user.email.blank? && user = User.find_by_email(vk_user.email)
      # User was created by parsing email. Add missing attrbute.
      user.update_user_from_vk_graph(vk_user, access_token)
    else
      user = User.create_user_from_vk_graph(vk_user, access_token)
    end
    user
  end

  def self.find_or_create_for_facebook_oauth(facebook_user)
    #logger.debug facebook_user.to_yaml
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

  def get_genders
    if self.looking_for_gender == LOOKING_FOR_BOTH
      [USER_MALE, USER_FEMALE]
    elsif self.looking_for_gender == LOOKING_FOR_MALE
      [USER_MALE]
    else
      [USER_FEMALE]
    end
  end

  # fetch the requested users that the user is sexually interested in
  def requested_that_user_may_like
    requested_hookups.reject! do |requested|
      (self.get_genders & requested.get_genders).length == 0
    end
    requested_hookups
  end

  def possible_hookups
    # First find nearby users
    users = users_nearby
    
    # Find active users
    if users.length < 20
      active_users = filter(User.active.where('gender IN (?)', get_genders)).take(20)
      users = users.concat(active_users)
    end

    # Ok find friends on facebook
    if users.length < 20
      friends = filter(User.where(:id => self.friends.pluck(:id) ).where('gender IN (?)', get_genders))
      users = users.concat(friends)
    end
    
    # Ok find anyone on the system in the same city
    if users.length < 20
      local_users = filter(User.where('gender IN (?)', get_genders).where(vk_city_id: vk_city_id)).take(20)
      users = users.concat(local_users )
    end
    
    # Any one on the system
    if users.length < 20
      all_users = filter(User.where('gender IN (?)', get_genders)).take(20)
      users = users.concat(all_users)
    end
    
    users
  end

  def filter(users)
    if self.relationships.blank?
      return users
    else
      return users.where('id NOT IN (?)', exclude_ids.push(id)).order("num_requests DESC")
    end
  end

  def exclude_ids
    #relationships.pluck(:id)
    relationships.where("status IN (?)", ['pending', 'accepted', 'rejected']).pluck(:hookup_id)
    #(hookups.pluck(:id) + pending_hookups.pluck(:id) + rejected_hookups.pluck(:id))
  end

  def users_nearby
    if self.geocoded?
      users = self.nearbys(20)
      unless users.blank? 
        users = filter(users.where('gender IN (?)', get_genders)).take(20) 
        return users
      end
    end
    []
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

  def flirt(friend)
    User.flirt(self, friend)
  end
  handle_asynchronously :flirt

  def self.reject(user, friend)
     unless user == friend or user.relationships.exists?(hookup_id: friend.id)
      transaction do
        Relationship.create(:user => user, :hookup => friend, :status => 'rejected')
        Relationship.create(:user => friend, :hookup => user, :status => 'rejected')
      end
    end
  end

  def reject(friend)
   User.reject(self, friend)
  end
  handle_asynchronously :reject
  
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

  # syncing 
  def self.update_friends
    User.active.each do |user|
      user.get_friends
      sleep 4
    end
  end

  def self.update_photos
    User.active.each do |user|
      user.get_photos
      sleep 2
    end
  end


  def headers_for(action)
    if action == :confirmation_instructions
      { bcc: "" }
    else
      {}
    end
  end

  def self.update_requested_cache_column
    User.active.find_each do |user|
      user.update_attribute(:num_requests, user.requested_hookups.length) 
    end
  end
end
