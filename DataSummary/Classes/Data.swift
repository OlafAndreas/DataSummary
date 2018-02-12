//
//  Data.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 06.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import Foundation

public struct SData {
    
    public struct Section: DataSection {
        public var name: String
        public var sorting: Int
        public var items: [DataItem]
    }
    
    public struct Item: DataItem {
        public var name: String
        public var sorting: Int
        public var grouping: Int
        public var fields: [DataField]
    }
    
    public struct Field: DataField {
        public var name: String
        public var sorting: Int
        public var value: Double?
        public var children: [DataField]?
    }
    
    ///
    /// Gets an array of example data with random values.
    ///
    /// - returns: An array of DataSection objects.
    ///
    public static func getExampleData() -> [DataSection] {
        
        let events = SData.Section(name: "Section 1", sorting: 0, items: [
            SData.Item(name: "Item 1", sorting: 1, grouping: rand(2), fields: fields),
            SData.Item(name: "Item 2", sorting: 2, grouping: rand(2), fields: fields),
            SData.Item(name: "Item 3", sorting: 3, grouping: rand(2), fields: fields),
            SData.Item(name: "Item 4", sorting: 4, grouping: rand(2), fields: fields)
            ].sorted(by: { first, last in first.sorting < last.sorting }))
        
        let criteria = SData.Section(name: "Section 2", sorting: 1, items: [
            SData.Item(name: "Item 1", sorting: 1, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 2", sorting: 2, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 3", sorting: 3, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 4", sorting: 4, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 5", sorting: 5, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 6", sorting: 6, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 7", sorting: 7, grouping: rand(3), fields: fields),
            SData.Item(name: "Item 8", sorting: 8, grouping: rand(3), fields: fields)
            ].sorted(by: { first, last in first.sorting < last.sorting }))
        
        return [events, criteria]
    }
    
    private static var fields: [DataField] {
        return [
            SData.Field(name: "Field 1", sorting: 1, value: rand(6), children: nil),
            SData.Field(name: "Field 2", sorting: 2, value: rand(6), children: nil),
            SData.Field(name: "Field 3", sorting: 3, value: rand(6), children: nil)
        ]
    }
    
    private static func rand(_ upperBound: UInt32) -> Int {
        return Int(arc4random_uniform(upperBound))
    }
    
    private static func rand(_ upperbound: UInt32) -> Double {
        let random: Int = rand(upperbound)
        return Double(random)
    }
}
