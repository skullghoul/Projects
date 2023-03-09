//
//  SettingsTableViewController.swift
//  RandomPersonApi
//
//  Created by Zander Ewell on 2/27/23.
//

import UIKit


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var switchOutlets: [UISwitch]!
    
    
    @IBOutlet weak var stepperLabel: UILabel!
    
    
    @IBOutlet weak var stepper: UIStepper!
    
    var inclusionParameters = [String]()
    
    var stepperInfo = 1
    
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        
        let parameter: String
        switch sender.tag {
        case 0:
            
            parameter = "gender"
        case 1:
            parameter = "location"
        case 2:
            parameter = "email"
        case 3:
            parameter = "login"
        case 4:
            parameter = "registered"
        case 5:
            parameter = "dob"
        case 6:
            parameter = "phone"
        case 7:
            parameter = "cell"
        case 8:
            parameter = "id"
        case 9:
            parameter = "nat"
        default:
            
            parameter = ""
            break
        }
        
        if sender.isOn {
            inclusionParameters.append(parameter)
        } else {
            inclusionParameters.removeAll { value in
                value == parameter
            }
        }
    }
    
    
    @IBAction func stepperClicked(_ sender: Any) {
        
        stepperLabel.text = "\(Int(stepper.value))"
        stepperInfo = (Int(stepper.value))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark  
        
        stepper.maximumValue = Double.infinity
        stepper.minimumValue = 1
        
        stepperLabel.text = "1"
        
        stepper.value = 1
        
        switchOutlets[0].tag = 0
        switchOutlets[1].tag = 1
        switchOutlets[2].tag = 2
        switchOutlets[3].tag = 3
        switchOutlets[4].tag = 4
        switchOutlets[5].tag = 5
        switchOutlets[6].tag = 6
        switchOutlets[7].tag = 7
        switchOutlets[8].tag = 8
        switchOutlets[9].tag = 9
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            if let destinationVC = segue.destination as? DisplayUserTableViewController {
                destinationVC.inclusionParameters = inclusionParameters
                destinationVC.stepperInfo = stepperInfo
            }
        }
    }
}


