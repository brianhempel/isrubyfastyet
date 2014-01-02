Feature: Viewing listings
	In order to sell stuff
	a seller
	can mange listings
	
	Scenario: Viewing a listing
		Given a listing exists with a title of "Old Car"
		When I go to the homepage
		And I follow "Old Car"
		Then I should see "Old Car"
		And I should see "Place a bid"
	
	Scenario: Adding a listing
		Given I am logged in
		When I go to the homepage
		And I follow "Sell"
		And I fill in "Title" with "Beanie Babies"
		And I fill in "Description" with "They're Lovable!"
		And I press "Create Listing"
		Then I should see "Beanie Babies"
		
	Scenario: Bidding on a listing
		Given a listing exists with a title of "Old Car"
		And I am logged in
		When I go to the homepage
		And I follow "Old Car"
		And I fill in "Amount" with "100.00"
		And I press "Bid"
		Then I should see "$100.00"
	
	Scenario: Deleting a listing
		Given the following listing exists:
			| Title   | user                      |
			| Old Car | email: daniel@example.com | 
		And I am logged in as "daniel@example.com"
		When I go to the homepage
		And I follow "Old Car"
		And I follow "Delete"
		Then I should not see "Old Car"
		
