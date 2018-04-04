//
//  DataSectionHeader.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 02.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import UIKit

class DataSectionHeader: UICollectionReusableView {
    
    static let identifier = "Data_Section_Header"
    
    var section: DataSection!
    
    var palette: ColorPalette!
    
    var titleLabel: UILabel!
    
    public func setup(using section: DataSection, with palette: ColorPalette) {
        self.section = section
        self.palette = palette
        
        titleLabel = UILabel(frame: bounds.insetBy(dx: 5, dy: 0))
        
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(titleLabel)
        
        backgroundColor = palette.collectionHeaderBackgroundColor
        
        titleLabel.textColor = palette.collectionHeaderTextColor
        
        titleLabel.text = section.name
    }
}
