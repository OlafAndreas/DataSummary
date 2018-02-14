//
//  ColorPalette.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 06.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import UIKit

public struct ColorPalette {
    
    public init(dataFieldBackgroundColor: UIColor,
        dataFieldTextColor: UIColor,
        backgroundColor: UIColor,
        evenCellBackgroundColor: UIColor,
        oddCellBackgrounColor: UIColor,
        textColor: UIColor,
        collectionHeaderBackgroundColor: UIColor,
        collectionHeaderTextColor: UIColor){
        
        self.dataFieldBackgroundColor = dataFieldBackgroundColor
        self.dataFieldTextColor = dataFieldTextColor
        self.backgroundColor = backgroundColor
        self.evenCellBackgroundColor = evenCellBackgroundColor
        self.oddCellBackgrounColor = oddCellBackgrounColor
        self.textColor = textColor
        self.collectionHeaderBackgroundColor = collectionHeaderBackgroundColor
        self.collectionHeaderTextColor = collectionHeaderTextColor
    }
    
    public var dataFieldBackgroundColor: UIColor
    public var dataFieldTextColor: UIColor
    public var backgroundColor: UIColor
    public var evenCellBackgroundColor: UIColor
    public var oddCellBackgrounColor: UIColor
    public var textColor: UIColor
    public var collectionHeaderBackgroundColor: UIColor
    public var collectionHeaderTextColor: UIColor
}
