//
//  ViewController.swift
//  testSonogramMacOS
//
//  Created by Roman Ustiantcev on 09/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import Cocoa

class MacViewController: NSViewController {
    
    @IBOutlet weak var myView: MacSonogramView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "test", withExtension: "m4a") {
            myView.addDurationOfFileWith(url: url)
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

