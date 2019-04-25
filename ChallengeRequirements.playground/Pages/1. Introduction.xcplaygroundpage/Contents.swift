/*:
 
 # Introduction
 
 Greetings! Please review this document and complete the following tasks. The goal of this exercise is to touch on various aspects of everyday iOS
 coding here at Weedmaps.
 
 You may spend no longer than 1 week to return back.
 
 You may go as deep as you like with your solution, the only ask is to meet the requirements. In general we want to get a sense of how well you understand iOS project development.
 
 
 
 
 # Requirements
 
 ## Overview

 - A project template has been provided for you which you should already have if you are reading this.
 - Build a Universal (iPhone, iPad) application that leverages the [Yelp API](https://www.yelp.com/developers/documentation/v3).
 We would like to see solutions making use of functional programming, types, protocols, and generics, etc.
 - Use 100% Swift if possible.
 - Avoid using 3rd party frameworks besides the networking framework provided (Alamofire). If you do decide to leverage additional 3rd party frameworks, be prepared to justify your reasoning for your decision.
 - Avoid downloading images or other assets unnecessarily. Make use of an image cache. (Show us how well you know GCD and threading)
 - Use Codable Protocol for Model Serialization. We have provided a Business.swift model, but feel free to add additional models.
 
 ## Networking
 
 - You will first need to build out the included Alamofire dependency using [CocoaPods](https://cocoapods.org/). We have already included a Podfile so you will just need to build the Pod dependency
 - We expect you to build your networking layer with scalability in mind. Try to avoid hard coded URLs when available and operate under the assumption that you could port this to a production ready application.
 
 ## Interface
 
 ![EXAMPLE](searchbar.png)
 
 - Build an interface with user submittable search query. Leverage the Yelp API w/ GPS coordinates from [CoreLocation.framework](https://developer.apple.com/documentation/corelocation).
 - Present the results in a UICollectionView.
 - There are additional instructions provided for you in the HomeViewController.swift class. When a user taps on a collection view cell, an action-sheet style UIAlertController with a choice to Cancel,
 Open in Safari, or Open in Webview. The details that you display can simply be the Yelp detail page that is likely provided for you in the initial API request.

 ![EXAMPLE](collectionview.png)
 
 - Page in additional data as the user reaches the end of the content.
 - Page in intervals of 15.
 - Cache search queries to disk and display past caches queries. The caching mechanism is up to you, just be sure that you can justify your reasoning for using a specific approach.
 
 ![EXAMPLE](recentsearches.png)
 
 - Use the BusinessCell.xib and BusinessCell.swift files to create your cell representation. The label should be able to autosize itself to include up to 3 lines of text.
 - Be sure to leverage Autolayout constraints to display your UI elements within the cell.
 - Support various width devices (should an iPad and iPhone SE share the same size traits?)
 - There is an additional FavoritesViewController.swift class that you may implement if you have additional time and want to show off more of your skills. This can simply display a UITableView or UICollectionView
 that lists the items that a user has tapped on, ranked by how often a user has viewed the details for a specific business. For example, if Joe's Pizza business detail view (either in Safari or from the WKWebView) was viewed twice via the details from the HomeViewController, and World's Best Burgers was viewed 4 times,
 the data would be displayed as World's Best Burgers in row 0 and Joe's Pizza in row 1.

 ## Tests
 
 - Add unit tests for any network interfaces created. These unit tests should make use of test data.
 - Add a minimum of 1 XCUI test testing part of your interface. There is an example test provided for you in the project template.
 
 ## Packaging
 
 - Package your source code and host in a publicly accessible git repository. [Github](https://www.Github.com), [Bitbucket](https://www.Bitbucket.com), and [Gitlab](https://www.Gitlab.com) offer free accounts.
 
 ## Notes
 
 - Avoid using 3rd party code. If you must, use [Carthage](https://github.com/Carthage/Carthage)
 - This exercise is intentionally generic to test various fundamentals. Focus on threading, access control(public/private), autolayout, error handling, etc
 - The project should compile with the current public released Xcode version and make use of build flag 'Treat Warnings as Errors'
 - Your project should not crash.
 
 
 ## Conclusion
 
 This exercise is intended to give you enough flexibility to showcase your strengths, while also touching on various fundamentals.
 
 The screenshots attached are only for reference purposes and should not be copied verbatim.

 */
