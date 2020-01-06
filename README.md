# DietCardsApp, iOS Developer: Elias H.

**Run instructions:** 
Xcode 11.3, DietCards.xcworkspace, iPhone 11 Pro, light mode, portrait only, user needs username and password at login screen.

**Overview:** 
Overview: This is a diet calorie sharing app. Users can see/follow another’s daily consumed foods.

**Walkthrough:**
User logs in if not in any group they tap the join group yellow button, which takes them to AddGroupController. If this is there second try They will have fetched group name from core data automatically. 
User decides if he once to create his own group or join anothers group. He taps one of the buttons and enters name of group he wants to create or join. User is dismissed back to HomeViewController if successful
User is now part of group or group creator so now user has access to cards. They can tap on day of the week to see/add nutrition on that day.
If they are not the creator they can only view. If they are creator they can tap on add button to add food item. User inputs name of food item they want to search using Nutritionix api. When they have downloaded the calorie information using alamofire in FoodClient. They are returned to table view.
Group creator has ability to delete food item by swipe if user wants to. This removes food item from user database.

**User permissions:**
Group Creator: Read and Write Permission on database
Group Follower: Read only permission on database.

**Tools used:** **Xcode 11.3**, **iphone 11 Pro simulator**, **UIKit**, **Alamofire 5**, **Firebase-Realtime Database**, **Nutritionix API**, **Core Data** to fetch/save group name so user is automatically in their last accessed group.

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
