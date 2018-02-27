# DataSummary

[![CI Status](http://img.shields.io/travis/olaf.ovrum@gmail.com/DataSummary.svg?style=flat)](https://travis-ci.org/olaf.ovrum@gmail.com/DataSummary)
[![Version](https://img.shields.io/cocoapods/v/DataSummary.svg?style=flat)](http://cocoapods.org/pods/DataSummary)
[![License](https://img.shields.io/cocoapods/l/DataSummary.svg?style=flat)](http://cocoapods.org/pods/DataSummary)
[![Platform](https://img.shields.io/cocoapods/p/DataSummary.svg?style=flat)](http://cocoapods.org/pods/DataSummary)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Usage
```swift
		// Initalizes the UIViewController
		let summaryViewController = DataSummary()
        
        // Gets a set of example data
        let data = SData.getExampleData()
        
        // Converts the data to a statistical format
        let statistics = DataSummaryWorker.generateStatisticalData(from: data)
        
        // Prepares the UIViewController with the provided data
        summaryViewController.setup(sections: statistics)

        // Present the DataSummary
        present(summaryViewController, animated: true, completion: nil)
```

## Requirements

## Installation

DataSummary is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DataSummary'
```

## Author

olaf.ovrum@gmail.com, olaf@huconglobal.com

## License

DataSummary is available under the MIT license. See the LICENSE file for more info.
