//
//  StatsTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

class StatsTableViewCell : UITableViewCell {
    
    // stores the values of the action struct in the label's text fields
    var stats : StatsRow? {
        didSet {
            for index in stats!.points.indices {
                if index == 0 {
                    statImage0.image = stats?.imageName
                    pointDisplay0.text = "\(String(describing: stats!.points[0])) / \(String(describing: stats!.totalPoints[0]))"
                } else if index == 1 {
                    statImage1.image = stats?.imageName
                    pointDisplay1.text = "\(String(describing: stats!.points[1])) / \(String(describing: stats!.totalPoints[1]))"

                } else if index == 2 {
                    statImage2.image = stats?.imageName
                    pointDisplay2.text = "\(String(describing: stats!.points[2])) / \(String(describing: stats!.totalPoints[2]))"
                } else if index == 3 {
                    statImage3.image = stats?.imageName
                    pointDisplay3.text = "\(String(describing: stats!.points[3])) / \(String(describing: stats!.totalPoints[3]))"
                }
            }
        }
    }
    
    private let statImage0 : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit // image will never be strecthed vertically or horizontally
        image.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
//        image.layer.cornerRadius = 13
        image.clipsToBounds = true
        return image
    }()
    
    private let statImage1 : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit // image will never be strecthed vertically or horizontally
        image.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    private let statImage2 : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit // image will never be strecthed vertically or horizontally
        image.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let statImage3 : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit // image will never be strecthed vertically or horizontally
        image.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    
    private let pointDisplay0 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 12)
        label.textAlignment = .right
        label.textColor = .black
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private let pointDisplay1 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 12)
        label.textAlignment = .right
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    private let pointDisplay2 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 12)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    private let pointDisplay3 : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "munro", size: 12)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        statImage0.translatesAutoresizingMaskIntoConstraints = false
        pointDisplay0.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statImage0)
        addSubview(pointDisplay0)
        addSubview(statImage1)
        addSubview(pointDisplay1)
        addSubview(statImage2)
        addSubview(pointDisplay2)
        addSubview(statImage3)
        addSubview(pointDisplay3)
        // anchors the two strings based on their relative position within the cell and each other
        statImage0.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        pointDisplay0.anchor(top: topAnchor, left: statImage0.rightAnchor, bottom: bottomAnchor, right: statImage1.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 10, width: 40, height: 0, enableInsets: false)
        statImage1.anchor(top: topAnchor, left: pointDisplay0.rightAnchor, bottom: bottomAnchor, right: pointDisplay1.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 20, height: 0, enableInsets: false)
        pointDisplay1.anchor(top: topAnchor, left: statImage1.rightAnchor, bottom: bottomAnchor, right: statImage2.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 10, width: 40, height: 0, enableInsets: false)
        statImage2.anchor(top: topAnchor, left: pointDisplay1.rightAnchor, bottom: bottomAnchor, right: pointDisplay2.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 20, height: 0, enableInsets: false)
        pointDisplay2.anchor(top: topAnchor, left: statImage2.rightAnchor, bottom: bottomAnchor, right: statImage3.leftAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 10, width: 40, height: 0, enableInsets: false)
        statImage3.anchor(top: topAnchor, left: pointDisplay2.rightAnchor, bottom: bottomAnchor, right: pointDisplay3.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 20, height: 0, enableInsets: false)
        pointDisplay3.anchor(top: topAnchor, left: statImage3.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 40, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
