class Image < ActiveRecord::Base
  attr_accessible :image, :provider, :external_id, :remote_url
  belongs_to :user

   has_attached_file :image,
    :storage => :s3,
    :bucket => CONFIG[:aws_bucket],
    :s3_credentials => {
      :access_key_id => CONFIG[:aws_access],
      :secret_access_key => CONFIG[:aws_secret]
    },
    :s3_host_alias => '',
    :url => ':s3_alias_url',
    :styles => { :default => "640x640>" },
    :path => "#{CONFIG[:aws_path]}/users/:attachment/:id/:style/:basename.:extension"

    def photo_url
      if image?
        image.url(:default)
      else
        remote_url
      end
    end
end