class Image < ActiveRecord::Base
  belongs_to :user

   has_attached_file :image,
    :storage => :s3,
    :bucket => CONFIG[:aws_bucket],
    :s3_credentials => {
      :access_key_id => CONFIG[:aws_access],
      :secret_access_key => CONFIG[:aws_secret]
    },
    :styles => { :thumb => "100x100>" },
    :path => "#{CONFIG[:aws_path]}/users/:attachment/:id/:style/:basename.:extension"
end