//
//  Extensions.swift
//  DataSummary
//
//  Created by Olaf Øvrum on 13.02.2018.
//

import Foundation

extension UIView {
    
    func contain(in parent: UIView, withHeight: CGFloat = 0, using inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        
        let bottomConstraint = withHeight > 0 ?
            self.heightAnchor.constraint(equalToConstant: withHeight)
            :
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: inset.bottom)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset.left),
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: inset.top),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: inset.right),
            bottomConstraint
            ])
    }
}
