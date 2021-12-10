//
//  passwordvalidation.swift
//  test
//
//  Created by HimenoTowa on 11/24/21.
//

import Foundation


class passwordvalidation{
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{6,}$")
        return passwordTest.evaluate(with: password)
    }
    
}
