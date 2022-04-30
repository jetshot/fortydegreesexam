//
//  ViewController.swift
//  fortydegreesexam
//
//  Created by Collabera on 4/26/22.
//

import UIKit
import AutocompleteField

class ViewController: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameErrorLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var stateTF: AutocompleteField!
    @IBOutlet weak var stateErrorLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var countryTF: AutocompleteField!
    @IBOutlet weak var countryErrorLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stateTF.isEnabled = false
        countryTF.isEnabled = false
        nameErrorLbl.textColor = .red
        stateErrorLbl.textColor = .red
        countryErrorLbl.textColor = .red
        RestApiManager.shared.getCountries(data: [String:String](), onCompletion: { json in
            DispatchQueue.main.async {
                if let countries = json.array {
                    var countriesArr = [String]()
                    var regions = [String]()
                    countries.forEach { country in
                        let region = country["region"].string ?? ""
                        regions.append(region)
                        
                        if let name = country["name"].dictionary {
                            let common = name["common"]?.string ?? ""
                            countriesArr.append(common)
                        }
                        
                    }
                    self.stateTF.suggestions = regions
                    self.stateTF.isEnabled = true
                    self.countryTF.suggestions = countriesArr
                    self.countryTF.isEnabled = true
                }
            }
        })
    }

    @IBAction func submitTapped(_ sender: Any) {
        if nameTF.text == "" {
            nameErrorLbl.text = "Please fill name field."
            return
        }
        if stateTF.text == "" {
            stateErrorLbl.text = "Please fill state field."
            return
        }
        if countryTF.text == "" {
            countryErrorLbl.text = "Please fill country field."
            return
        }
        let nameIsValid =  nameTF.text!.range(of: ".*[^A-Za-z].*", options: .regularExpression)
        if nameIsValid != nil {
            nameErrorLbl.text = "Cannot contain alpha numeric characters"
            return
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = nameTF.text!
        vc.state = stateTF.text!
        vc.country = countryTF.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        
    }
    
}

