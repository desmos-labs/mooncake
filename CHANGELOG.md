# Version 0.5.2
## Bug fixes
- Fixed a bug when creating a post
- Fixed a bug when displaying the error message on posts

# Version 0.5.1
## Changes
- Removed the usage of the `open` field from the poll data since it's no longer going to be used in future Desmos version 

# Version 0.5.0
## Changes
- Added the possibility of having multiple accounts at the same time
- Changed the likes and reactions visualization
- Added the possibility of scrolling to the top of the posts list by clicking the posts list button
- Improved the editing screen UX  
- Updated the dependencies

## Bug fixes
- Fixed a bug that caused the posts list to jump to the top if the screen switched to the account page and back to the posts list

# Version 0.4.4
## Bug fixes
- Fixed some synchronization bugs

# Version 0.4.3
## Changes
- Improved how failed-to-sync posts are displayed
- Added the possibility of retrying the sync or deleting failed-to-sync posts

## Bug fixes
- Fixed the mnemonic backup popup from displaying if the user logged in using their mnemonic backup
- Fixed the registration flow to allow the user to return back to the login page

# Version 0.4.2
## Changes
- Added the option to remove a poll during the post creation
- Improved the poll visualization during the post creation
- Added link previews to posts
- Added a popup to tell you the causes of synchronization errors
- UX and UI improvements

## Bug fixes
- Fixed a bug that caused the funds to not be asked when needed
- Fixed the visualization of poll results
- Fixed a bug that caused a wrong visualization of single posts' details

# Version 0.4.1
## Changes
- Added the proper error visualization inside the mnemonic recovery screen
- Added a check to make sure users read the disclaimer before viewing their mnemonic
- Improved the account edit UX to make sure it's easier to change any information

## Bug fixes
- Fixed the visualization of the posts' messages to make sure newlines are shown properly
- Fixed the visualization of the posts' times based on the devices location
- Fixed the font visualization on iOS devices

# Version 0.4.0
## Changes
- Implemented the profiles.
  Creating or editing a profile costs **0.20 Daric**.
- Operations fees have changed. Now they are:
  - **0.10 Daric** per post or comment
  - **0.05 Daric** per reaction or like added or removed
  - **0.05 Daric** per poll answer
- Implemented users jazz icons instead of old identicons
- Implemented the ability of exporting and importing the mnemonic as an encrypted object safely
- Removed the ability to manually set the app theme. Now it is the same set system-wide.
- Added mnemonic phrase backup popup reminder

## Improvements
- Improved the themes colors
- Improved the posts loading time
- Improved the overall UX and UI

## Bug fixes
- Fix a UI bug that did not display markdown correctly in post details
- Created function to filter out non unique likes to fix bug displaying multiple likes by same user in one post.

# Version 0.3.2
## Changes
- Improved the colors schema
- Added the ability to view the number of votes and ending date of a poll
- Added the ability to block a user

## Bug fixes
- Removed the constant warning for new posts even tho there were none
- Fixed the visualization of the users that have liked a post

# Version 0.3.1
## Bug fixes
- Fixed a huge performance problem inside the posts list

# Version 0.3.0
## Changes
- Added the possibility of creating polls
- Added the possibility of voting to existing polls
- Added the ability to view your own mnemonic phrase from withing the app
- Added a fee of 0.10 daric while sending the transactions
- Improved the visualization of your wallet balance

## Bug fixes
- Fixed a bug that caused the impossibility of using the biometric protection when creating a new account
- Fixed a UI bug inside the post details that didn't allow for a proper visualization if the reactions and comments list were empty

# Version 0.2.1
## Bug fixes
- Fixed a bug inside the post creation

# Version 0.2.0
## Changes
- Added the possibility of reporting a post
- Added the possibility of hiding a post
- Added the possibility of scrolling past the latest 50 posts to load more
- Added the possibility of logging out
- Improved the colors of the dark mode
- Improved the comments UX while browsing through posts

## Bug fixes
- Fixed a bug that didn't allow to like or add a reaction to a post from within its detail screen
- Fixed the splash screen colors
- Fixed a bug that automatically made you log in after you uninstalled and re-installed the app
- Fixed a bug that didn't allow to show the images inside comments

# Version 0.1.0
Version `0.1.0` brings a brand new UX and UI for a simplified usage of the application. Here is a sneak peek at what has changed with this version.

### Once-click access
If you do not own a mnemonic phrase yet, you are not required to generate one to access the app the first time anymore. Instead, you can simply click the "Login" button and start using Mooncake right away.

### Improved posts list loading time
The initial posts loading time has been reduced and the overall process has been made faster even on older devices, so that you can always enjoy the best experience possibile.

### Re-designed posts list and posts details
The posts list and the post details screen have been completely re-designed in order to make you feel home as you where using any other social network.

Inside the post details screen you will now be able to visualize the list of reactions and who has added them too.

### Improved wallet experience
We've improved how you interact with your wallet, by making it more accessible and easier to comprehend.

### Many more
Many other changes have been made. Download the app now and check them out!

# Previous versions
Changelogs from `0.0.1` to `0.0.14` has been moved to the [PRE-RELEASES file](./PRE-RELEASES.md)
