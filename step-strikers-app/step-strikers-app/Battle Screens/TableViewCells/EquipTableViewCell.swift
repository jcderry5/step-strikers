//
//  EquipTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit
// class that creates the custom cells for the equip table when in battle
class EquipTableViewCell: UITableViewCell {
    
    // sets up a variable that is lets you get what was part of the Equip Struct
    // and stores it as a label's text
    var equip : Equip? {
        didSet {
            equipName.text = equip?.name
            equipQuantity.text = equip?.quantity
        }
    }
    
    // label for the name of weapon or armor in the equip menu
    private let equipName : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "munro", size: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    // label for how many of each weapon or armor a player has
    private let equipQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 20)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    // creates a custom cell and positions text how we want
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        equipName.translatesAutoresizingMaskIntoConstraints = false
        equipQuantity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(equipName)
        addSubview(equipQuantity)
        // anchors the name to the left of the row
        equipName.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 200, height: 0, enableInsets: false)
        // anchors the quantity based on how long the name is
        equipQuantity.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
