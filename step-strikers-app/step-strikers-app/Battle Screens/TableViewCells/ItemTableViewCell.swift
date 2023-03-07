//
//  ItemTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit
// the class for the custom cell for the item table in battle
class ItemTableViewCell: UITableViewCell {
    // creates a var that sets the label text with what value the struct contains
    var item : Items? {
        didSet {
            itemName.text = item?.name
            itemQuantity.text = item?.quantity
        }
    }
    
    // name label of item/consumable
    private let itemName : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "munro", size: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    // quantity of item
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
        // anchors the two strings based on their relative position within the cell and each other
        itemName.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 200, height: 0, enableInsets: false)
        itemQuantity.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
