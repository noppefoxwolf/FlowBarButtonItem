# FlowBarButtonItem

![](https://raw.githubusercontent.com/noppefoxwolf/FlowBarButtonItem/master/Example/sample.gif)


[![CI Status](http://img.shields.io/travis/Tomoya Hirano/FlowBarButtonItem.svg?style=flat)](https://travis-ci.org/Tomoya Hirano/FlowBarButtonItem)
[![Version](https://img.shields.io/cocoapods/v/FlowBarButtonItem.svg?style=flat)](http://cocoapods.org/pods/FlowBarButtonItem)
[![License](https://img.shields.io/cocoapods/l/FlowBarButtonItem.svg?style=flat)](http://cocoapods.org/pods/FlowBarButtonItem)
[![Platform](https://img.shields.io/cocoapods/p/FlowBarButtonItem.svg?style=flat)](http://cocoapods.org/pods/FlowBarButtonItem)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FlowBarButtonItem is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "FlowBarButtonItem"
```

## How to use.

```swift
import FlowBarButtonItem
```

```swift
let right = FlowBarButtonItem(image: UIImage(named: "image"), style: .Done, target: self, action: "rightAction:")
navigationItem.rightBarButtonItem = right
right.enableFlow()
```

## Author

Tomoya Hirano, cromteria@gmail.com

## License

FlowBarButtonItem is available under the MIT license. See the LICENSE file for more info.
