# == Schema Information
#
# Table name: posts
#
#  id      : integer          not null, primary key
#  status  : string(255)

# Using metaprogramming to create methods
class Post < ActiveRecord::Base
  ['Draft', 'Published', 'Pending', 'Rejected'].each do |method|
    define_singleton_method "#{method.downcase}" do
      where(status: method)
    end

    define_method "#{method.downcase}?" do
      status == method
    end

    define_method "#{method.downcase}!" do
      self.status = method
    end
  end
end