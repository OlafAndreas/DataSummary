//
//  ColorPalette.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 06.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import UIKit

public struct ColorPalette {
    
    /**
 
     Creates a ColorPalette with the given colors.
     
     - parameter dataFieldBackgroundColor: Background color of the data field header view, the one below the title.
        - dataFieldTextColor: Text color of the labels in the field header view.
        - backgroundColor: Background color of the root view.
        - evenCellBackgroundColor: Background color of the cells with an even index.
        - oddCellBackgroundColor: Background color of the cells with an odd index.
        - textColor: Text color of the labels within cells.
        - collectionHeaderBackgroundColor: Background color of the section headers.
        - collectionHeaderTextColor: Text color of the labels within section headers.
        - success: Text color of data field values above a given treshold that should receive styling.
        - danger: Text color of data field values below a given treshold that should receive styling.
        - warning: Text color of data field values below a given treshold that should receive styling.
     */
 
    public init(dataFieldBackgroundColor: UIColor,
        dataFieldTextColor: UIColor,
        backgroundColor: UIColor,
        evenCellBackgroundColor: UIColor,
        oddCellBackgrounColor: UIColor,
        textColor: UIColor,
        collectionHeaderBackgroundColor: UIColor,
        collectionHeaderTextColor: UIColor,
        success: UIColor,
        danger: UIColor,
        warning: UIColor){
        
        self.dataFieldBackgroundColor = dataFieldBackgroundColor
        self.dataFieldTextColor = dataFieldTextColor
        self.backgroundColor = backgroundColor
        self.evenCellBackgroundColor = evenCellBackgroundColor
        self.oddCellBackgrounColor = oddCellBackgrounColor
        self.textColor = textColor
        self.collectionHeaderBackgroundColor = collectionHeaderBackgroundColor
        self.collectionHeaderTextColor = collectionHeaderTextColor
        self.success = success
        self.danger = danger
        self.warning = warning
    }
    
    public var dataFieldBackgroundColor: UIColor
    public var dataFieldTextColor: UIColor
    public var backgroundColor: UIColor
    public var evenCellBackgroundColor: UIColor
    public var oddCellBackgrounColor: UIColor
    public var textColor: UIColor
    public var collectionHeaderBackgroundColor: UIColor
    public var collectionHeaderTextColor: UIColor
    public var success: UIColor
    public var danger: UIColor
    public var warning: UIColor
}
