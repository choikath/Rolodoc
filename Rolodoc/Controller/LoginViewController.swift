//
//  LoginViewController.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/6/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonPresssed(_ sender: Any) {
        if passwordField.text == "innov" {
            defaults.set(true, forKey: "loginSaved")
            performSegue(withIdentifier: "goToHome", sender: self)
        }
        else {
            shakeView(self.view.subviews[1])
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        passwordField.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func shakeView(_ shakeView: UIView) {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = 4
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
//        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
//
//        viewToShake.layer.add(animation, forKey: "position")
////
        let shake = CABasicAnimation(keyPath: "position")
        let xDelta = CGFloat(10)
        shake.duration = 0.09
        shake.repeatCount = 4
        shake.autoreverses = true

        let from_point = CGPoint(x: shakeView.center.x - xDelta, y: shakeView.center.y)
        let from_value = NSValue(cgPoint: from_point)

        let to_point = CGPoint(x: shakeView.center.x + xDelta, y: shakeView.center.y)
        let to_value = NSValue(cgPoint: to_point)

        shake.fromValue = from_value
        shake.toValue = to_value
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shakeView.layer.add(shake, forKey: "position")
    }
    
    

}
