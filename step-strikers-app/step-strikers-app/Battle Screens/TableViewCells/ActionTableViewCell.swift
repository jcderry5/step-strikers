//
//  ActionTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit
// class that creates the custom cells for the action table when in battle
class ActionTableViewCell: UITableViewCell {
    // stores the values of the action struct in the label's text fields
    var action : Action? {
        didSet {
            actionNameLabel.text = action?.name
            actionStaminaCost.text = action?.staminaCost
        }
    }
    
    private let actionNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "munro", size: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let actionStaminaCost : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 20)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        actionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        actionStaminaCost.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionNameLabel)
        addSubview(actionStaminaCost)
        // anchors the two strings based on their relative position within the cell and each other
        actionNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 220, height: 0, enableInsets: false)
        actionStaminaCost.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// taken from: https://medium.com/@kemalekren/swift-create-custom-tableview-cell-with-programmatically-in-ios-835d3880513d
// extension to the UIView to anchor custom cell contents within their row
extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
     let topInset = CGFloat(0)
     let bottomInset = CGFloat(0)
     
     translatesAutoresizingMaskIntoConstraints = false
     
     if let top = top {
     self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
     }
     if let left = left {
     self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
     }
     if let right = right {
     rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
     }
     if let bottom = bottom {
     bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
     }
     if height != 0 {
     heightAnchor.constraint(equalToConstant: height).isActive = true
     }
     if width != 0 {
     widthAnchor.constraint(equalToConstant: width).isActive = true
     }
     
     }
}
