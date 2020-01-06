# DietCardsApp, iOS Developer: Elias Hall

**Run Instructions:** 
Xcode 11.3, DietCards.xcworkspace, iphone pro 11, lightMode, portrait only, user needs username and password at login screen.

**Overview:** 
Overview: This is a diet calorie sharing app. Users can see/follow another’s daily consumed foods.

**Walkthrough:**
User logs in if not in any group they tap the join group yellow button, which takes them to AddGroupController. If this is there second try They will have fetched group name from core data automatically. 
User decides if he once to create his own group or join anothers group. He taps one of the buttons and enters name of group he wants to create or join. User is dismissed back to HomeViewController if successful
User is now part of group or group creator so now user has access to cards. They can tap on day of the week to see/add nutrition on that day.
If they are not the creator they can only view. If they are creator they can tap on add button to add food item. User inputs name of food item they want to search using Nutritionix api. When they have downloaded the calorie information using alamofire in FoodClient. They are returned to table view.
Group creator has ability to delete food item by swipe if user wants to. This removes food item from user database.

**User Permissions:**
Group Creator: Read and Write Permission on database
Group Follower: Read only permission on database.

**Tools used:** xcode 11.3, iphone 11 pro simulator, Alamofire 5, Firebase Realtime Database, Nutritionix api, core data to fetch/save group name so user is automatically in their last accessed group.


