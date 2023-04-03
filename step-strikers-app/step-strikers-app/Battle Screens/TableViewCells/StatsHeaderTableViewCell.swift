//
//  StatsHeaderTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

class StatsHeaderTableViewCell: UITableViewCell {
    // stores the values of the action struct in the label's text fields
    var head : StatsHeaderRow? {
        didSet {
            player1.text = "\(head!.names[0])"
            player2.text = "\(head!.names[1])"
            player3.text = "\(head!.names[2])"
            player4.text = "\(head!.names[3])"
        }
    }
    
    private let player1 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private let player2 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    private let player3 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let player4 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        player1.translatesAutoresizingMaskIntoConstraints = false
        player2.translatesAutoresizingMaskIntoConstraints = false
        player3.translatesAutoresizingMaskIntoConstraints = false
        player4.translatesAutoresizingMaskIntoConstraints = false
        addSubview(player1)
        addSubview(player2)
        addSubview(player3)
        addSubview(player4)
        // anchors the two strings based on their relative position within the cell and each other
        player1.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 60, height: 0, enableInsets: false)
        player2.anchor(top: topAnchor, left: player1.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 40, width: 60, height: 0, enableInsets: false)
        player3.anchor(top: topAnchor, left: player2.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 60, height: 0, enableInsets: false)
        player4.anchor(top: topAnchor, left: player3.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 60, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
