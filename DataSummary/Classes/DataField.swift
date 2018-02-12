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
    var value: Double? { get }
    var children: [DataField]? { get }
}
