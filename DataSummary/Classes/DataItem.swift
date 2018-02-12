//
//  DataItem.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 02.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import Foundation

public protocol DataItem: Sortable, Named {
    var name: String { get }
    var fields: [DataField] { get }
    var grouping: Int { get }
}
