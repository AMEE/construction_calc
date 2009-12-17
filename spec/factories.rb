require 'factory_girl'

Factory.define :user do |u|
  u.sequence(:email) {|e| "email#{e}@testemail.com" }
  u.sequence(:login) {|l| "login#{l}" }
  u.password "rubbishpassword"
  u.password_confirmation "rubbishpassword"
  u.activated_at 10.seconds.ago
end

Factory.define :role do |r|
  r.role_type Role::Type::READER
end

Factory.define :project do |p|
  p.sequence(:name) {|n| "name#{n}" }
  p.sequence(:amee_profile) {|n| "amee_profile_#{n}"}
  p.floor_area 125000
  p.client {|c| c.association(:client) }
end

Factory.define :client do |c|
  c.sequence(:name) {|n| "name#{n}" }
end