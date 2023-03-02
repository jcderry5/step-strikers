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
    
    func createButton(x:Int, y:Int, w:Int, h:Int, text:String, fontSize:CGFloat) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x:x, y:y, width:w, height:h)
        button.setTitle(text, for:UIControl.State.normal)
        button.titleLabel!.font = UIFont(name: "munro", size: fontSize)
        button.setTitleColor(.black, for:.normal)
        button.setBackgroundImage(UIImage(named:"Menu Button"), for:UIControl.State.normal)
        button.setBackgroundImage(UIImage(named:"Selected Menu Button"), for:UIControl.State.highlighted)
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
    
}
