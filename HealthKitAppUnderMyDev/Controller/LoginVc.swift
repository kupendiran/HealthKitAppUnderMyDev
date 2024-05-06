//
//  LoginVc.swift
//  Piechips
//
//  Created by Kupendiran Alagarsamy on 04/05/22.
//

import UIKit

class LoginVc: BaseVC {
    
    @IBOutlet var loginView: LoginVw!
    //var loginViewModel = LoginViewModel()
    
    //
    //let s_getLoggedInUserId = Constants.appDelegate.s_getLoggedInUserId_GLOBAL_Use
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginView.setController(controller: self)
        
        
        updateMainQueue {
            self.loginView.designSetups()
        }//update_Main_Queue End,,,,,
        
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}




extension LoginVc {
    
}
