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
    
    public func setup(using section: DataSection, with palette: ColorPalette) {
        self.section = section
        self.palette = palette
        
        setupViews()
    }
    
    func setupViews() {
        
        let label = UILabel(frame: bounds.insetBy(dx: 5, dy: 0))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = section.name
        label.textColor = palette.collectionHeaderTextColor
        
        backgroundColor = palette.collectionHeaderBackgroundColor
        
        addSubview(label)
    }
}
