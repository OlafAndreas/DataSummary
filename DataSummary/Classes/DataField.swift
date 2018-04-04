//
//  Field.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 02.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import Foundation

///
/// Value and Children should not be used together.
/// Use Value when you want to display only one value for the field
/// Use Children when you want to display multiple values for the field.
///
public protocol DataField: Sortable, Named {
    
    /// The value to be displayed in the cell
    var value: Double? { get }
    
    /// The children that will be presented beneath this "header"
    var children: [DataField]? { get }
    
    /// Return true if this field should receive styling, otherwise false.
    var shouldReceiveStyling: Bool { get }
}
