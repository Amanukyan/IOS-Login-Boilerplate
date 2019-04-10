//
//  ViewController.swift
//  Login
//
//  Created by Alex Manukyan on 3/31/19.
//  Copyright © 2019 Alex Manukyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        print("ViewController - View did load")
        // Do any additional setup after loading the view.
        
        ApiClient.shared.register(username: "test2", password: "Test1234") { (result) in
            switch result {
            case .success(let json):
                print("SUCCES:", json)
                DispatchQueue.main.async {
                    self.showHomeViewContoller()
                }
            case .failure(let error):
                print("FAILURE:", error)
            }
        }
    }
    
    func showHomeViewContoller(){
        let vc = HomeViewController()
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDel.window?.rootViewController = vc
    }
}

