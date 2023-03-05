//
//  InventoryTableViewCell.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/4/23.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    
    // TODO: Implement a variable that accepts label values 
    
    private let image : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named:"battle_axe")
        return imageView
    }()
    
    private let name : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "munro", size: 15)
        label.text = "HELLO THERE"
        return label
    }()
    
    private let quantity : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "munro", size: 15)
        label.text = "x10"
        return label
    }()
    
    // Override initializer to create a custom cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)
        contentView.addSubview(name)
        contentView.addSubview(quantity)
    }
    
    // Required for intializer above
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Define the layout of all subviews
    override func layoutSubviews() {
        // TODO: Fix these awful configurations
        super.layoutSubviews()
        image.frame = CGRect(x: 5, y: 5, width: 100, height: contentView.frame.size.height - 10)
        name.frame = CGRect(x: 10+image.frame.size.width, y: 0, width: 100, height: contentView.frame.size.height - 10)
        quantity.frame = CGRect(x: 10+name.frame.size.width, y: 3, width: 100, height: contentView.frame.size.height - 10)
    }
}
