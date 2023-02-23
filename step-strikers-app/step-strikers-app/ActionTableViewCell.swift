//
//  ActionTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
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
        actionNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        actionStaminaCost.anchor(top: topAnchor, left: actionNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
     var topInset = CGFloat(0)
     var bottomInset = CGFloat(0)
     
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
