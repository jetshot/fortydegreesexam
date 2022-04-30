//
//  DashboardViewController.swift
//  fortydegreesexam
//
//  Created by Collabera on 4/26/22.
//

import UIKit

class DashboardViewController: UIViewController {

    var name: String = ""
    var state: String = ""
    var country: String = ""
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Hi \(name)\n\nYou are from \(state), \(country)\n\nYour capital is:"
    }
    

}
