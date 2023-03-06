//
//  InventoryTableViewCell.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/4/23.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    
    // Implement a variable that accepts label values
    var inventoryObj : inventoryStruct? {
        didSet {
            name.text = inventoryObj?.name
            quantity.text = "x\(inventoryObj!.quantity)"
            image.image = inventoryObj?.image
        }
    }
    
    private let image : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let name : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "munro", size: 24)
        return label
    }()
    
    private let quantity : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "munro", size: 24)
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
        super.layoutSubviews()
        image.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.height - 10, height: contentView.frame.size.height - 10)
        name.frame = CGRect(x: 30+image.frame.size.width, y: 3, width: 200, height: contentView.frame.size.height - 10)
        quantity.frame = CGRect(x: 30+image.frame.size.width+name.frame.size.width, y: 3, width: 100, height: contentView.frame.size.height - 10)
    }
}
