Factory.define :listing do |f|
  f.title "MacBook Pro"
  f.description 'Some description'
  f.association :user
end

Factory.define :user do |f|
  f.sequence(:email) {|n| "user#{n}@example.com"}
  f.password 'password'
  f.password_confirmation {|user| user.password }
end