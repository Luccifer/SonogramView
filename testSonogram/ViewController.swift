//
//  ViewController.swift
//  testSonogram
//
//  Created by Roman Ustiantcev on 05/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myView: SonogramView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "test", withExtension: "m4a") {
            myView.addDurationOfFileWith(url: url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

