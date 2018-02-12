//
//  DataSection.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 02.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import Foundation

public protocol DataSection: Sortable, Named {
    var name: String { get }
    var items: [DataItem] { get }
}
