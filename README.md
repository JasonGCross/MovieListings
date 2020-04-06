# MovieListings

Simple iOS project which shows how to connect to a DataService written in C++.

Other interesting parts are:
* using Swift UI to create the views
* using Apple's Combine Framework to connect the data to the views

## Explanation of File Structure

```
MovieListings\ViewModel
```

* These are the model classes, groomed for consumption by the SwiftUI Views.
* Using the MVVM design pattern, these Models are called "ViewModel" classes


```
MovieListings\View
```

* These are the SwiftUI Views


```
MovieListing\Library
```

* This is where the C++ DataController lives
* The C++ classes are wrapped in Objective-C classes


## Requirements to Run

At the time of writing, this project used 

Area                  | Version
----------------------|--------
XCode                 | 11.4
Swift                 | 5.2
iOS Deployment Target | 13.4
