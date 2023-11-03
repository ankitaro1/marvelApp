//
//  ViewController.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openMArvelButtonTapped(_ sender: Any) {
        guard let navStack = self.navigationController else { return }
        let router = Router(navstack: navStack)
        router.moveToMarvelListScreen()
    }
    
}

