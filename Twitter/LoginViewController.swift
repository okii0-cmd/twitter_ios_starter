//
//  LoginViewController.swift
//  Twitter
//
//  Created by okii on 4/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func onLoginButton(_ sender: Any) {
        // put code to run on button press.
        //action is what happens when someone taps on the button
        
        let url = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: url, success: {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            UserDefaults.standard.set(true, forKey: "userLoggedIn")// userlogged in set to true
            //remember that user have already logged in , don't ask again
        }, failure: { Error in
            print("Cannot log in!")
        })
        
        
        //checking this URL, to see if this request is succesful
        //what to do if succesful, what to do if unsuccesful.
        //the URL we are using for log in . If log in work = success
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear (_ animated: Bool){
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
}
