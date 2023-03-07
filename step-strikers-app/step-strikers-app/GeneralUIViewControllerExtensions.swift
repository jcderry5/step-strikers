//
//  GeneralUIViewControllerExtensions.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/28/23.
//

import UIKit
import FirebaseFirestore

extension UIViewController {
    
    func assignBackground() {
        let background = UIImage(named: "Background")
        var imageView: UIImageView!
        imageView = UIImageView(frame: self.view.frame)
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    func createLabel(x:Int, y:Int, w:Int, h:Int, font:String, size:CGFloat, text:String, align:NSTextAlignment) -> UILabel {
        let label = UILabel(frame: CGRect(x:x, y:y, width:w, height:h))
        label.textAlignment = align
        label.text = text
        label.font = UIFont(name:font, size:size)
        view.addSubview(label)
        return label
    }
    
    func createTextField(x:Int, y:Int, w:Int, h:Int, secured:Bool) -> UITextField! {
        let field = UITextField(frame: CGRect(x:x, y:y, width:w, height:h))
        field.backgroundColor = UIColor.white
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.isSecureTextEntry = secured
        field.autocapitalizationType = .none
        view.addSubview(field)
        return field
    }
    
    func createButton(x:Int, y:Int, w:Int, h:Int, text:String, fontSize:CGFloat, normalImage:UIImage, highlightedImage:UIImage) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x:x, y:y, width:w, height:h)
        button.setTitle(text, for:UIControl.State.normal)
        button.titleLabel!.font = UIFont(name: "munro", size: fontSize)
        button.setTitleColor(.black, for:.normal)
        button.setBackgroundImage(normalImage, for:UIControl.State.normal)
        button.setBackgroundImage(highlightedImage, for:UIControl.State.highlighted)
        view.addSubview(button)
        return button
    }
    
    func createImage(x:Int, y:Int, w:Int, h:Int, name:String) -> UIImageView {
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x, y:y, width:w, height:h))
        imageView.image = UIImage(named:name)
        view.addSubview(imageView)
        return imageView
    }
    
    func createNotification() {
        let notificationView = UIView(frame: CGRect(x:8,y:27,width:359,height:90))
        let background = UIImageView(frame: notificationView.frame)
        background.clipsToBounds = true
        background.image = UIImage(named:"Banner")
        background.center = notificationView.center
        notificationView.addSubview(background)
        
        // Create banner label and icon
        let label = UILabel(frame: CGRect(x:100, y:57, width:249, height:31))
        label.text = "You found a new item!"
        label.font = UIFont(name:"munro", size:24)
        notificationView.addSubview(label)
        let symbol = UIImageView(frame: CGRect(x:25, y:46, width:60, height:54))
        symbol.image = UIImage(named:"Notification Icon")
        notificationView.addSubview(symbol)
        
        // Pressing the banner will redirect the user to the inventory screen
        let push = UIButton()
        push.frame = notificationView.frame
        push.addTarget(self, action:#selector(pushPressed), for:.touchUpInside)
        notificationView.addSubview(push)
        view.addSubview(notificationView)
    }
    
    @objc private func pushPressed(_ sender:UIButton!) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InventoryViewController") as! InventoryViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
}
