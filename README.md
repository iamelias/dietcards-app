# DietCardsApp, iOS Developer: Elias H.

**Run instructions:** 
Xcode 11.3, iOS Deployment Target: 12.4, DietCards.xcworkspace, iPhone 11 Pro, light mode, portrait only, user needs username and password at login screen.

**Overview:** 
This is a diet calorie sharing app. Users can see/follow another’s daily consumed foods.

**Walkthrough:**
User logs in. If they are not in any group, they will tap the "Join Group" yellow button which will take them to AddGroupController. In AddGroupController, user taps the Create or Join group button and enters name of group they want to create or join. If succesful in creating/joining group, the user is dismissed back to HomeViewController. Note: If data is persisted, they will have fetched the group name from core data automatically.
User is now part of a group as a member or creator. User now has access to cards(CardTableViewController). They can tap on a card, to see or add food items for that day.
If they are not the creator they can only view CardTableViewController. If they are the creator they can tap on the add button to access AddFoodItemController to add a food item to table and database. In the AddFoodItemController, the user inputs the name of the food item they want to add, which searches for the food item using the Nutritionix API. After adding the food item, they are returned to the food table view(CardTableViewController).
In the CardTableViewController, only the group creator has the ability to delete a food item by swipe, if the creator wants to. This removes food item from user database.

**User permissions:**
Login Required
Group Creator: Read and Write Permission on database
Group Follower: Read only permission on database.

**Tools used:** **Xcode 11.3**, **iphone 11 Pro simulator**, **UIKit**, **Alamofire 5**, **Firebase-Realtime Database**, **Nutritionix API**, **Core Data** to fetch/save group name so user is automatically in their last accessed group.

**Select below for larger clearer image**

<p float="left">
<img src = "Images/Screen%20Shot%202020-01-05%20at%2011.33.33%20AM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%2011.48.49%20AM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%2011.48.01%20AM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%206.34.31%20PM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%2011.44.07%20PM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-06%20at%2012.58.16%20AM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%2011.52.19%20AM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%206.34.48%20PM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%206.35.35%20PM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-05%20at%206.35.40%20PM.png" width="100" height="200">
<img src = "Images/Screen%20Shot%202020-01-06%20at%2012.58.26%20AM.png" width="100" height="200">

</p>
