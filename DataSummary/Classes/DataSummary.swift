//
//  ViewController.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 01.02.2018.
//  Copyright © 2018 Hucon Global AS. All rights reserved.
//

import UIKit

public class DataSummary: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dataCollectionView: UICollectionView?
    
    var nameLabelWidthConstraint: NSLayoutConstraint?
    
    var nameLabelWidth: CGFloat {
        return view.frame.width * 0.33
    }
    
    public struct MetaField {
        
        public struct Attributes {
            public let label: [NSAttributedStringKey: Any]
            public let value: [NSAttributedStringKey: Any]
        }
        
        static let defaultAttributes = MetaField.Attributes(label: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .regular)], value: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10, weight: .thin)])
        
        public init(label: String, value: String, attributes: Attributes? = nil) {
            self.label = label
            self.value = value
            self.attributes = attributes ?? MetaField.defaultAttributes
        }
        
        let label: String
        let value: String
        let attributes: Attributes?
    }
    
    // A default color palette providing colors for the various parts of the data summary view.
    var palette = ColorPalette(
        dataFieldBackgroundColor: UIColor.darkGray,
        dataFieldTextColor: UIColor.lightText,
        backgroundColor: UIColor.darkGray,
        evenCellBackgroundColor: UIColor.gray,
        oddCellBackgrounColor: UIColor.lightGray,
        textColor: UIColor.darkText,
        collectionHeaderBackgroundColor: UIColor.white,
        collectionHeaderTextColor: UIColor.darkText,
        success: UIColor.green,
        danger: UIColor.red,
        warning: UIColor.yellow
    )
    
    /// Holds all the data fields for the data sections.
    /// This will be populated by the datafields defined in the in the first item in the first section.
    /// All fields should have the exact same attributes, or else the 'spreadsheet' will be a cluttered mess.
    var dataFields: [DataField]!
    
    var metaFields: [[MetaField]]?
    
    // Data source of the collectionView, this holds the root-level DataSection objects.
    private var sections: [DataSection]! {
        didSet {
            dataCollectionView?.reloadData()
        }
    }
    
    ///
    /// Sets the data to be displayed, also adds some optional configurations to the mix.
    ///
    /// - parameter sections: An array of DataSection objects.
    /// - parameter usePalette: The ColorPalette to use when presenting the view. A default palette is used if not defined.
    /// - parameter statusBarStyle: The UIStatusBarStyle to be used when presenting the view.
    ///
    public func setup(sections dataSections: [DataSection], metaFields: [[MetaField]]? = nil, usePalette: ColorPalette? = nil, statusBarStyle: UIStatusBarStyle? = nil) {
        
        if dataSections.count == 0 { return print("No data available in sections parameter.") }
        
        self.sections = dataSections.sorted(by: { first, last in first.sorting < last.sorting })
        
        // Get the data fields of the first item in the first section,
        // this will be used to create a header with the field names describing the values.
        // The first field will always be Name, no need to define this every time.
        // The sorting of Name is set to -1 to ensure it always is setup at the start.
        
        dataFields = sections.first!.items.first!.fields.sorted(by: { first, last in first.sorting < last.sorting })
        
        if let palette = usePalette {
            self.palette = palette
        }
        
        if let statusBarStyle = statusBarStyle {
            UIApplication.shared.statusBarStyle = statusBarStyle
        }
        
        setupViews()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        
        updateNameLabelWidthConstraint()
        dataCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func updateNameLabelWidthConstraint() {
        
        nameLabelWidthConstraint?.constant = nameLabelWidth
        
        view.setNeedsUpdateConstraints()
    }
    
    func setupViews() {
        
        view.backgroundColor = palette.backgroundColor
        
        if sections.count == 0 {
            
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 40)
            label.text = "No data provided."
            
            view.addSubview(label)
            
            return
        }
        
        let contentStack = UIStackView(frame: view.bounds.insetBy(dx: 0, dy: 20))
        contentStack.spacing = 1
        contentStack.axis = .vertical
        view.addSubview(contentStack)
        
        let titleLabel = UILabel()
        titleLabel.textColor = palette.textColor
        titleLabel.text = "Data Report"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        contentStack.addArrangedSubview(titleLabel)
        
        let metaRows: [[MetaField]] = []/*[[
            MetaField(label: "Collection", value: "OPC 3"),
            MetaField(label: "Location", value: "Sola, Stavanger"),
            MetaField(label: "Somelabel", value: "Somevalue")],[
            MetaField(label: "Instructor", value: "Nordmann, Ola"),
            MetaField(label: "Start Date", value: "99:99:99 9999-99-99")]]*/
        
        for row in metaRows {
            
            let metaStack = UIStackView()
            metaStack.distribution = .fillEqually
            metaStack.axis = .horizontal
            metaStack.spacing = 1
            
            let metaFieldStack = UIStackView()
            metaFieldStack.axis = .horizontal
            metaFieldStack.distribution = .equalCentering
            
            metaFieldStack.addArrangedSubview(UIView())
            
            for field in row {
                
                let fieldStack = UIStackView()
                fieldStack.axis = .vertical
                
                let textAttributes = [NSAttributedStringKey.foregroundColor: palette.textColor]
                
                let label = UILabel()
                label.backgroundColor = palette.collectionHeaderBackgroundColor
                
                let labelString = NSMutableAttributedString(string: field.label, attributes: field.attributes?.label)
                
                labelString.addAttributes(textAttributes, range: NSRange(location: 0, length: field.label.count))
                
                label.attributedText = labelString
                
                fieldStack.addArrangedSubview(label)
                
                let value = UILabel()
                value.backgroundColor = palette.collectionHeaderBackgroundColor
                
                let valueString = NSMutableAttributedString(string: field.value, attributes: field.attributes?.value)
                
                valueString.addAttributes(textAttributes, range: NSRange(location: 0, length: field.value.count))
                
                value.attributedText = valueString
                
                fieldStack.addArrangedSubview(value)
                
                metaFieldStack.addArrangedSubview(fieldStack)
            }
            
            metaFieldStack.addArrangedSubview(UIView())
            
            contentStack.addArrangedSubview(metaFieldStack)
        }
        
        let dataFieldContentStack = UIStackView()
        dataFieldContentStack.backgroundColor = palette.dataFieldBackgroundColor
        
        contentStack.addArrangedSubview(dataFieldContentStack)
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.textColor = palette.dataFieldTextColor
        nameLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: nameLabelWidth)
        nameLabelWidthConstraint?.isActive = true
        dataFieldContentStack.addArrangedSubview(nameLabel)
        
        let dataFieldNameStack = UIStackView()
        dataFieldNameStack.distribution = .fillEqually
        dataFieldNameStack.spacing = 1
        dataFieldContentStack.addArrangedSubview(dataFieldNameStack)
        
        for dataField in dataFields {
                
            if dataField.sorting == -1 { continue }
            
            let fieldStack = UIStackView()
            fieldStack.axis = .vertical
            
            let label = UILabel()
            label.text = dataField.name
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = palette.dataFieldTextColor
            
            // -1 is the sorting value of the name field
            if dataField.sorting == -1 {
                
                // Set the width of the name label to be equal to the name field in the items list.
                fieldStack.widthAnchor.constraint(equalToConstant: dataFieldContentStack.bounds.width * 0.25)
            } else {
                
                // Only fields after the name field needs to have their textAlignment set to center.
                label.textAlignment = .center
            }
            
            fieldStack.addArrangedSubview(label)
            
            if let children = dataField.children {
                
                let childStack = UIStackView()
                childStack.distribution = .fillEqually
                
                for child in children {
                    
                    let childLabel = UILabel()
                    childLabel.textAlignment = .center
                    childLabel.textColor = palette.dataFieldTextColor
                    childLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
                    
                    childLabel.text = child.name
                    
                    childStack.addArrangedSubview(childLabel)
                }
                
                fieldStack.addArrangedSubview(childStack)
            }
            
            dataFieldNameStack.addArrangedSubview(fieldStack)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        
        dataCollectionView = UICollectionView(frame: CGRect(x: dataFieldContentStack.frame.minX, y: dataFieldContentStack.frame.maxY, width: dataFieldContentStack.frame.width, height: contentStack.bounds.height - dataFieldContentStack.frame.maxY), collectionViewLayout: layout)
        
        guard let dataCollectionView = self.dataCollectionView else { return }
        
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        dataCollectionView.register(DataItemCell.self, forCellWithReuseIdentifier: DataItemCell.identifier)
        dataCollectionView.register(DataSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DataSectionHeader.identifier)
        dataCollectionView.backgroundColor = palette.backgroundColor
        dataCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(dataCollectionView)
        
        dataCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dataCollectionView.topAnchor.constraint(equalTo: dataFieldContentStack.bottomAnchor).isActive = true
        dataCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dataCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataItemCell.identifier, for: indexPath) as! DataItemCell
        
        let dataItem = sections[indexPath.section].items[indexPath.item]
        
        cell.setup(using: dataItem, with: palette, at: indexPath)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DataSectionHeader.identifier, for: indexPath) as! DataSectionHeader
        
        let section = sections[indexPath.section]
        
        header.setup(using: section, with: palette)
        
        return header
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
}

