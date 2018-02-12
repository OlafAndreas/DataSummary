//
//  DataItemCell.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 01.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import UIKit

class DataItemCell: UICollectionViewCell {
    
    static let identifier = "Data_Item_Cell"
    
    var item: DataItem?
    var palette: ColorPalette?
    var indexPath: IndexPath?
    
    public func setup(using item: DataItem, with palette: ColorPalette, at indexPath: IndexPath) {
        self.item = item
        self.palette = palette
        self.indexPath = indexPath
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        item = nil
        palette = nil
        indexPath = nil
    }
    
    func darkened(_ color: UIColor) -> UIColor {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r - 0.1, 0.0), green: max(g - 0.1, 0.0), blue: max(b - 0.1, 0.0), alpha: a)
        }
        
        return color
    }
    
    func setupViews() {
        
        guard let item = self.item, let palette = self.palette, let indexPath = self.indexPath else { return }
        
        let backgroundColor = indexPath.item % 2 == 0 ? palette.evenCellBackgroundColor : palette.oddCellBackgrounColor
        
        backgroundView = UIView(frame: bounds)
        backgroundView!.backgroundColor = backgroundColor
        
        let stackView = UIStackView(frame: bounds.insetBy(dx: 10, dy: 0))
        stackView.spacing = 1
        
        let borderView = UIView(frame: stackView.bounds)
        stackView.addSubview(borderView)
        borderView.backgroundColor = UIColor.black
        
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.textColor = palette.textColor
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.backgroundColor = backgroundColor
        
        stackView.addArrangedSubview(nameLabel)
        
        for field in item.fields {
            
            let fieldStack = UIStackView()
            fieldStack.axis = .vertical
            fieldStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            // Value should only be presented when there are no children present
            if let value = field.value, field.children == nil {
                
                let label = UILabel()
                label.textAlignment = .center
                label.textColor = palette.textColor
                label.backgroundColor = backgroundColor
                
                label.text = String(format: value == floor(value) ? "%.0f" : "%.1f", value)
                
                fieldStack.addArrangedSubview(label)
            }
            
            if let children = field.children {
                
                let childStack = UIStackView()
                childStack.distribution = .fillEqually
                
                for (index, child) in children.sorted(by: { first, last in first.sorting < last.sorting }).enumerated() {
                    
                    let label = UILabel()
                    label.textAlignment = .center
                    label.textColor = palette.textColor
                    label.backgroundColor = index % 2 == 0 ? backgroundColor : darkened(backgroundColor)
                    
                    if let value = child.value {
                        label.text = String(format: value == floor(value) ? "%.0f" : "%.1f", value)
                    }
                    
                    childStack.addArrangedSubview(label)
                }
                
                fieldStack.addArrangedSubview(childStack)
            }
            
            stackView.addArrangedSubview(fieldStack)
        }
        
        contentView.addSubview(stackView)
    }
}
