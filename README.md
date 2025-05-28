# yatharthageeta

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Issue Fixes - 06/03/2025 (By Vaibhav)
Fixed Issues:
    1. Offline Mode Crash in Geeta Shlokas: The verse was updating after the buffer time ended, causing the app to crash.
        - In Shlokas Listing controller added sequenceStateStream listner to handle the verse updating
    2. Seek Bar Issue in Offline Mode: Moving the seek bar changed its position unexpectedly, leading to an app crash.
        - Added condion on seek bar if internet is gone
    3. Player Not Resuming After Network Reconnection: When Wi-Fi was disabled and re-enabled, the player did not resume from its last position.
        - Using internet service listener in (controls.dart) to handle to pause and resume the shlokas in internet gone scenario.

Files Modified:
    -   widgets/player.dart
    -   widgets/controls.dart
    -   widgets/miniplayer.dart
    -   controllers/shlokas_listing_controllers.dart
    -   controllers/player_controller.dart


Issue Fixes Code Simplified - 13/03/2025 (By Vaibhav)
Fixed Issues: 
    1. After the internet disconnects, playback continues until the buffered portion ends, then it keeps skipping to the next audio. To prevent this, I added an internet check to stop the player from jumping to the next track.
Files Modified:
    -   widgets/player.dart

Code Simplified : 
    1. Simplified the listining to sequence stream to check if there are next or previous chapters in the audio in createPlaylist() method
    2. Simplified the modelData() method where keys are checked maually, and here i used update() directly
    3. Simplified the initialize verse of the player controller logic by removing redundant conditions, used .indexWhere() instead of for loop to find the chapter, Handled empty chaptersList.
Files Modified:
    -   widgets/player.dart

Issue Fixes - 19/03/2025 (By Vaibhav)
    1. Either audio download should resume after internet or download icon should not be there
    2. Mobile[Satsang videos]: Gray screen should not be there
    3. Mobile[Geeta Shlokas]: Next button should be there when language change is there
    4. Mobile[Yatharth Geeta audios]: Audio see all listing red box error should not be there
    5. Mobile[Satsang videos]: Handle no internet on video details page
    6. Mobile[Satsang videos]: After turn off the internet user should be able to access the page
    7. Mobile[Satsang videos]: Handle video seekbar when internet is turned off

Issue Fixes - 01/04/2025 (By Vaibhav)
    1. Fixed Grey screen issue of IOS in scenario where turn off the net and remove the app from recent and open the apk again
    2. Added Route observer service 
    3. Added app_error_widget to handle global error and release grey screen issues 

Issue Fixes - 08/04/2025 (By Vaibhav)
    1. Device is conncted with data or wifi but if there is no actual data is comming then in ashram audio it behave abruptly and jumping to the next shloka, fix this issue by adding internet_connction_checker_plus library cause the connctivity_plus is only checking the connctivity not the actual connction, so listing the internet status by internet_connction_checker_plus library

    
# Yatharth-Geeta
