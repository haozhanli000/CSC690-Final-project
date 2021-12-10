//
//  LoginViewController.swift
//  test
//
//  Created by HimenoTowa on 11/24/21.
//
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernametextfield: UITextField!
    
    @IBOutlet weak var passwordtextfield: UITextField!
    
    @IBOutlet weak var errorlabel: UILabel!
    
    @IBOutlet weak var loginbutton: UIButton!
    
    
    @IBAction func loginsubmit(_ sender: Any) {
            
        let email = usernametextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = passwordtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password){
            (result,error) in
            
            if error != nil{
                self.errorlabel.text = error!.localizedDescription
                self.errorlabel.alpha = 1
            }
            else{
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? NavigationViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
    }
    
   
}

