//
//  DataSummaryWorker.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 02.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import Foundation

///
/// A worker that prepares data in a variety of formats for the DataSummary to present.
///
public class DataSummaryWorker {
    
    ///
    /// Generate statistics data based on a data collection
    ///
    /// - parameter data: The data collection to create the statistical data from.
    ///
    /// - returns: A data collection containing data fields with average and standard deviation fields.
    public class func generateStatisticalData(from data: [DataSection]) -> [DataSection] {

        // We will manipulate the items of each section to provide average, standard deviation, count and number of 0 or 1's in the scores.
        // Items with the same grouping will be collapsed to one item, the grouping value is typically an unique id.
        
        var sections: [DataSection] = []
        
        for section in data {
        
            // Create a new section objec to store data in, data coming from the data array is immutable because of the DataSection conformance.
            // Therefore we need to create an object that is mutable.
            var deltaSection = SData.Section(name: section.name, sorting: section.sorting, items: [])
            
            // Items in every group will be collapsed into one item
            let groupedItems = Dictionary(grouping: section.items, by: { (item: DataItem) in item.grouping })
            
            // Storage for collapsed items, will later be added to the deltaSection
            var collapsedItems: [DataItem] = []
            
            // Iterate through all groups to collapse their items
            for group in groupedItems.sorted(by: { first, last in first.key < last.key }) {
                
                // Copy the groups' item to get a mutable variable
                var items = group.value
                
                // Remove the first item from items and store it for later use
                let first = items.removeFirst()
                
                let firstItem = SData.Item(name: first.name, sorting: first.sorting, grouping: first.grouping, fields: first.fields)
                
                // Reduce the items using the first removed item as the initial result,
                // all other items will be collapsed with the initial result.
                var collapsedItem: SData.Item = items.reduce(firstItem, { result, item in
                    
                    // Collapse the current item with the initial result, and return the collapsed item.
                    return collapse(result, with: item)
                })
                
                // Get an item with the averageFields, use group.value.count instead of items.count, remember we removed the first item of items? ;)
                collapsedItem = itemWithAverageFields(for: collapsedItem, originalItems: group.value)
                
                let zeroOrOneField = SData.Field(name: "0 or 1", sorting: collapsedItem.fields.count, value: Double(
                    
                    items.compactMap({ $0.fields }).joined().filter({
                        
                        // Fields with no values returns false
                        guard let value = $0.value else { return false }
                        
                        // Evaluate the value to be equal to 1 or 0
                        return value == 0 || value == 1
                        
                    }).count
                
                ), children: nil, shouldReceiveStyling: false)
                collapsedItem.fields.append(zeroOrOneField)
                
                // Add all collapsed items for this group to the collapsedItems array.
                collapsedItems.append(collapsedItem)
            }
            
            // Set the items of deltaSection to the collapsedItems array.
            deltaSection.items = collapsedItems
            
            // Add deltaSections to the sections array.
            sections.append(deltaSection)
        }
        
        // Returns the sections array with the collapsed items, this is now ready for the DataSummary presentation.
        return sections
    }
    
    private class func itemWithAverageFields(for item: SData.Item, originalItems: [DataItem]) -> SData.Item {
        
        var deltaItem = SData.Item(name: item.name, sorting: item.sorting, grouping: item.sorting, fields: item.fields)
        
        var deltaFields: [DataField] = []
        
        for field in deltaItem.fields {
            
            if let value = field.value {
                
                var deltaField = SData.Field(name: field.name, sorting: field.sorting, value: field.value, children: field.children)
                
                var children = field.children ?? []
                
                // Add average field
                let average = value / Double(originalItems.count)
                let averageField = SData.Field(name: "AVG", sorting: children.count, value: average, children: nil)
                children.append(averageField)
                
                // Add standard deviation field
                
                // Step 1: Find the mean
                // The mean value is already accessible using the average variable declared above.
                
                // Step 2: For each data point, find the square of its distance to the mean.
                // Create one array containing all fields in all items.
                let allFields = originalItems.map({ $0.fields }).joined()
                
                // Create an array of fields corresponding to the current field name.
                let fields = allFields.filter({ $0.name == field.name })
                
                // Create an array of values from all fields, this will also safely unwrap the optional value.
                let values = fields.compactMap({ $0.value })
                
                // Create an array of the square roots of the distance between the field value and the average value.
                let squaredDistances = values.map({ sqrt(fabs($0 - average)) })

                // Step 3: Sum the values from Step 2.
                let squaredDistancesSum = squaredDistances.reduce(0, +)
                
                // Step 4: Divide by the number of data points.
                let sumDividedByCount = squaredDistancesSum / Double(originalItems.count)
                
                // Step 5: Take the square root.
                let standardDeviation = sqrt(sumDividedByCount)
                
                let standardDeviationField = SData.Field(name: "SD", sorting: children.count, value: standardDeviation, children: nil, shouldReceiveStyling: false)
                children.append(standardDeviationField)
                
                deltaField.children = children
                
                deltaFields.append(deltaField)
            }
        }
        
        // Add count field
        let countField = SData.Field(name: "Count", sorting: deltaFields.count, value: Double(originalItems.count), children: nil)
        deltaFields.append(countField)
        
        deltaItem.fields = deltaFields
        
        return deltaItem
    }
    
    ///
    /// Collapses two items into one item.
    ///
    /// - parameter item: The base item to be collapsed upon.
    /// - parameter with: The item to collapse into the base item.
    ///
    /// - returns: A collapsed DataItem.
    private class func collapse(_ item: DataItem, with: DataItem) -> SData.Item {
        
        // Create an array to hold the collapsed data fields.
        var deltaFields: [DataField] = []
        
        // Iterate through all the fields from the item to collapse.
        for field in with.fields {
        
            // Create a mutable copy of the data field.
            var deltaField = SData.Field(name: field.name, sorting: field.sorting, value: field.value, children: field.children)
            
            // If a value is set, we will ignore the childrens for this item. This is because value and children should not be used at the same time.
            if let value = field.value {
                
                // Attempt to get the base field corresponding to the current field name.
                let baseField = item.fields.first(where: { $0.name == field.name })
                
                // Increment the deltaField value with the baseField + this fields' value
                deltaField.value = (baseField?.value ?? 0) + value
                
                // Append the deltaField to the deltaFields. These will "replace" the old data fields.
                deltaFields.append(deltaField)
                
                // Since we are working on a value, continue to next iteration. Childrens should not be present at this point anyway.
                continue
            }
            
            // No value is set in the field, collapse the datafield childrens, if there are any present.
            if let children = field.children {
                
                // Get a collapsed field by collapsing children into the delta field.
                deltaField = collapse(children, into: deltaField)
                
                // Append the collapsed field to the deltaFields array.
                deltaFields.append(deltaField)
            }
        }
     
        // Create and return a copy of the base item with the new collapsed fields.
        return SData.Item(name: item.name, sorting: item.sorting, grouping: item.grouping, fields: deltaFields)
    }
    
    ///
    /// Collapses an array of DataField into a baseField.
    ///
    /// - parameter children: The children array to be collapsed.
    /// - parameter into: The inout Data.Field object to receive the collapsed children.
    ///
    private  class func collapse(_ children: [DataField], into baseField: DataField) -> SData.Field {

        // Create a mutable copy of the baseField.
        var deltaField = SData.Field(name: baseField.name, sorting: baseField.sorting, value: baseField.value, children: baseField.children)

        // Check if the base has any children, if not return.
        guard let baseChildren = deltaField.children else { return deltaField }

        // Iterate through all children and collapse one by one.
        for child in children {
            
            // Check if the baseChildren contains a field with the corresponding name
            if let baseChildField = baseChildren.first(where: { $0.name == child.name }) {
                
                // Collapse the child with the corresponding baseField.
                let collapsedChild = collapse(child, into: baseChildField)
                
                // For every child collapsed, the collapsed child should be collapsed with the deltaField.
                deltaField = collapse(collapsedChild, into: deltaField)
            }
        }
        
        // Return the collapsed field.
        return deltaField
    }
    
    ///
    /// Collapses two fields into one field.
    ///
    /// - parameter field: The field to be collapsed into the second one.
    /// - parameter into: The field to receive the collapsed item.
    ///
    private class func collapse(_ field: DataField, into baseField: DataField) -> SData.Field {
        
        // Create a mutable copy of the base field.
        var collapsedChild = SData.Field(name: baseField.name, sorting: baseField.sorting, value: baseField.value, children: baseField.children)
        
        // Add values of both fields into the collapsedChild.
        collapsedChild.value = (field.value ?? 0) + (baseField.value ?? 0)
        
        // Return the collapsed child.
        return collapsedChild
    }
}
