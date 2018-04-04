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
    
    var nameLabelWidthConstraint: NSLayoutConstraint?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let constraint = nameLabelWidthConstraint else { return }
        
        constraint.constant = (frame.width * 0.33) - 10
        contentView.setNeedsUpdateConstraints()
    }
    
    func setupViews() {
        
        guard let item = self.item, let palette = self.palette, let indexPath = self.indexPath else { return }
        
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let backgroundColor = indexPath.item % 2 == 0 ? palette.evenCellBackgroundColor : palette.oddCellBackgrounColor
        
        backgroundView = UIView(frame: bounds)
        backgroundView!.backgroundColor = backgroundColor
        
        let rootStackView = UIStackView()
        rootStackView.spacing = 1
        rootStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        rootStackView.isLayoutMarginsRelativeArrangement = true
        rootStackView.contain(in: contentView)
        
        // This view adds a black seperator line between fields
        let stackBackgroundView = UIView(frame: CGRect(x: 100, y: 0, width: bounds.width-100, height: bounds.height))
        stackBackgroundView.backgroundColor = UIColor.black
        rootStackView.addSubview(stackBackgroundView)
        
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.textColor = palette.textColor
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.backgroundColor = backgroundColor
        nameLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: frame.width * 0.33)
        nameLabelWidthConstraint?.isActive = true
        rootStackView.addArrangedSubview(nameLabel)
        
        let itemStackView = UIStackView()
        itemStackView.spacing = 1
        itemStackView.distribution = .fillEqually
        rootStackView.addArrangedSubview(itemStackView)
        
        for field in item.fields {
            
            let fieldStack = UIStackView()
            fieldStack.axis = .vertical
            
            let labelFont = UIFont.systemFont(ofSize: 12)
            
            // Value should only be presented when there are no children present
            if let value = field.value, field.children == nil {
                
                let label = UILabel()
                label.font = labelFont
                label.textAlignment = .center
                label.textColor = palette.textColor
                label.backgroundColor = backgroundColor
                
                label.text = String(format: value == floor(value) ? "%.0f" : "%.1f", value)
                
                fieldStack.addArrangedSubview(label)
            } else if let children = field.children {
                
                let childStack = UIStackView()
                childStack.distribution = .fillEqually
                
                for (index, child) in children.enumerated() {
                    
                    let label = UILabel()
                    label.font = labelFont
                    label.textAlignment = .center
                    label.textColor = palette.textColor
                    label.backgroundColor = index % 2 == 0 ? backgroundColor : darkened(backgroundColor)
                    
                    if let value = child.value {
                        
                        label.text = String(format: value == floor(value) ? "%.0f" : "%.1f", value)
                        
                        // Only appy styling if this field should receive it.
                        if child.shouldReceiveStyling {
                        
                            if value < 2 {
                                
                                if value < 1 {
                                    
                                    label.textColor = palette.danger
                                    
                                } else {
                                    
                                    label.textColor = palette.warning
                                }
                                
                            } else if value > 4 {
                                
                                label.textColor = palette.success
                            }
                        }
                    }
                    
                    childStack.addArrangedSubview(label)
                }
                
                fieldStack.addArrangedSubview(childStack)
            }
            
            itemStackView.addArrangedSubview(fieldStack)
        }
    }
}
