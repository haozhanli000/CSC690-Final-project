//
//  ViewController.swift
//  test
//
//  Created by HimenoTowa on 11/23/21.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var loginbutton: UIButton!
    
    @IBOutlet weak var signupbutton: UIButton!
    
    @IBAction func loginbutton(_ sender: Any) {
        let isPresentingInAddFluidPatientMode = presentingViewController is LoginViewController
        
        if isPresentingInAddFluidPatientMode {
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
   
    }

}

