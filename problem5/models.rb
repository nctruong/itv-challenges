
# == Schema Information
#
#  id    :integer          not null, primary key
#  name  :string(255)
class User < ActiveRecord::Base
  has_many :posts
end

# == Schema Information
#
#  id      :integer          not null, primary key
#  title   :string(255)
#  user_id :integer
class Post < ActiveRecord::Base
  belongs_to :user, touch: true
end