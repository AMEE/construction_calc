class Client < ActiveRecord::Base
  
  validates_length_of :name, :maximum => 100
  validates_format_of :name, :with => /\A[\w -]+\Z/, :message => "Name must be letters, numbers or underscores only"
  
  has_many :roles, :as => :allowable
  has_many :projects do
    def readable_by_user(user)
      find(:all).select {|p| user.can_read?(p)}
    end
  end
end