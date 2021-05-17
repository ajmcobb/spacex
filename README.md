## SpaceX Challenge

Written with XCode 12.4 on a MBP M1.

Architecture: MVVM-C without any reactive libraries.

The challenge is still missing some Unit and UI tests, and probably needs polishing. This is because I could only spare 2 and 1/2 days to do it.

Some Autolayout issues appear when changing the sort order on the tableview with animations, so updating the tableview happens without animation.

Some Autolayout issues also appear when showing the UIAlertController (https://stackoverflow.com/questions/60647478/) 

