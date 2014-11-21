#Displaying a ShinobiChart on WATCH



#How To

You'll need to add a Watch App target to your application first. Select 'Add Target' in XCode, and select Apple Watch -> Watch App. The default settings will do for now, so select finish.

![Watch App Target Setup](images/add_watch_target.png "Adding a Watch App Target")


[The WatchKit programming guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/WatchKitProgrammingGuide/DesigningaWatchKitApp.html "WatchKit Programming Guide") states that 'If your iOS app and WatchKit extension rely on the same data, use a shared app group to store that data. An app group is an area in the local file system that both the extension and app can access.'