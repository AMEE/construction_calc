class Client < ActiveRecord::Base
  has_many :roles, :as => :allowable
  has_many :projects do
    def readable_by_user(user)
      find(:all).select {|p| user.can_read?(p)}
    end
  end
end