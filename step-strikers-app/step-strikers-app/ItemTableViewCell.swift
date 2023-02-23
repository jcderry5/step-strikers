//
//  ItemTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    var item : Item? {
        didSet {
            itemName.text = item?.name
            itemQuantity.text = item?.quantity
        }
    }
    
    private let itemName : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "munro", size: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let itemQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 20)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemName.translatesAutoresizingMaskIntoConstraints = false
        itemQuantity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(itemName)
        addSubview(itemQuantity)
        itemName.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        itemQuantity.anchor(top: topAnchor, left: itemName.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
