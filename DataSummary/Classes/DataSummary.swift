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
    
    // A default color palette providing colors for the various parts of the data summary view.
    var palette = ColorPalette(
        dataFieldBackgroundColor: UIColor.darkGray,
        dataFieldTextColor: UIColor.lightText,
        backgroundColor: UIColor.darkGray,
        evenCellBackgroundColor: UIColor.gray,
        oddCellBackgrounColor: UIColor.lightGray,
        textColor: UIColor.darkText,
        collectionHeaderBackgroundColor: UIColor.white,
        collectionHeaderTextColor: UIColor.darkText
    )
    
    /// Holds all the data fields for the data sections.
    /// This will be populated by the datafields defined in the in the first item in the first section.
    /// All fields should have the exact same attributes, or else the 'spreadsheet' will be a cluttered mess.
    var dataFields: [DataField]!
    
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
    public func setup(sections dataSections: [DataSection], usePalette: ColorPalette? = nil, statusBarStyle: UIStatusBarStyle? = nil) {
        
        if dataSections.count == 0 { return print("No data available in sections parameter.") }
        
        self.sections = dataSections.sorted(by: { first, last in first.sorting < last.sorting })
        
        // Get the data fields of the first item in the first section,
        // this will be used to create a header with the field names describing the values.
        // The first field will always be Name, no need to define this every time.
        
        dataFields = sections.first!.items.first!.fields.reduce([SData.Field(name: "Name", sorting: 0, value: nil, children: nil)], { result, field in
            var temp = result!
            temp.append(field)
            return temp
        })
        
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
        
        dataCollectionView?.collectionViewLayout.invalidateLayout()
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
        
        let dataFieldContentView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        dataFieldContentView.translatesAutoresizingMaskIntoConstraints = false
        dataFieldContentView.backgroundColor = palette.dataFieldBackgroundColor
        dataFieldContentView.contain(in: view, withHeight: 50)
        
        let dataFieldNameStack = UIStackView()
        dataFieldNameStack.distribution = .fillEqually
        dataFieldNameStack.spacing = 1
        dataFieldNameStack.contain(in: dataFieldContentView)
        
        for dataField in dataFields
            .sorted(by: { first, last in first.sorting < last.sorting }) {
                
                let fieldStack = UIStackView()
                fieldStack.axis = .vertical
                
                let label = UILabel()
                label.text = dataField.name
                label.textColor = palette.dataFieldTextColor
                
                // Only fields after the first one needs to have their textAlignment set to center.
                if dataField.sorting > 0 {
                    label.textAlignment = .center
                }
                
                fieldStack.addArrangedSubview(label)
                
                if let children = dataField.children?.sorted(by: { first, last in first.sorting < last.sorting }) {
                    
                    let childStack = UIStackView()
                    childStack.distribution = .fillEqually
                    
                    for child in children {
                        
                        let childLabel = UILabel()
                        childLabel.textAlignment = .center
                        childLabel.textColor = palette.dataFieldTextColor
                        
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
        
        self.dataCollectionView = UICollectionView(frame: CGRect(x: 0, y: dataFieldContentView.frame.maxY, width: view.frame.width, height: view.frame.height - dataFieldContentView.frame.maxY), collectionViewLayout: layout)
        
        guard let dataCollectionView = self.dataCollectionView else { return }
        
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        dataCollectionView.register(DataItemCell.self, forCellWithReuseIdentifier: DataItemCell.identifier)
        dataCollectionView.register(DataSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DataSectionHeader.identifier)
        dataCollectionView.backgroundColor = palette.backgroundColor
        dataCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dataCollectionView)
        
        dataCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dataCollectionView.topAnchor.constraint(equalTo: dataFieldContentView.bottomAnchor).isActive = true
        dataCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dataCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
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

