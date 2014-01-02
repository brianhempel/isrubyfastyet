Given "I am logged in" do
  user = Factory(:user, :password => 'secret')
  
  step 'I go to the homepage'
  step 'I follow "Sign In"'
  step %Q|I fill in "user_email" with "#{user.email}"|
  step 'I fill in "user_password" with "secret"'
  step 'I press "Sign in"'
end

Given 'I am logged in as "$email"' do |email|
  user = User.find_by_email(email)
  
  step 'I go to the homepage'
  step 'I follow "Sign In"'
  step %Q|I fill in "user_email" with "#{user.email}"|
  step 'I fill in "user_password" with "password"'
  step 'I press "Sign in"'
end