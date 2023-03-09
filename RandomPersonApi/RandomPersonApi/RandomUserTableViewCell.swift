//
//  RandomUserTableViewCell.swift
//  RandomPersonApi
//
//  Created by Zander Ewell on 2/28/23.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var identifierGender: UILabel!
    @IBOutlet weak var identifierLocation: UILabel!
    @IBOutlet weak var identifierEmail: UILabel!
    @IBOutlet weak var identifierLogin: UILabel!
    @IBOutlet weak var identifierRegistered: UILabel!
    @IBOutlet weak var identifierDOB: UILabel!
    @IBOutlet weak var identifierPhone: UILabel!
    @IBOutlet weak var identifierCell: UILabel!
    @IBOutlet weak var identifierID: UILabel!
    @IBOutlet weak var identifierNat: UILabel!
    
    
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var registeredLabel: UILabel!
    @IBOutlet weak var dOBLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var iDLabel: UILabel!
    @IBOutlet weak var NatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        
        genderLabel.adjustsFontSizeToFitWidth = true
        genderLabel.minimumScaleFactor = 0.2
        
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.minimumScaleFactor = 0.2
        
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.minimumScaleFactor = 0.2
        
        loginLabel.adjustsFontSizeToFitWidth = true
        loginLabel.minimumScaleFactor = 0.2
        
        registeredLabel.adjustsFontSizeToFitWidth = true
        registeredLabel.minimumScaleFactor = 0.2
        
        dOBLabel.adjustsFontSizeToFitWidth = true
        dOBLabel.minimumScaleFactor = 0.2
        
        phoneLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.minimumScaleFactor = 0.2
        
        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.minimumScaleFactor = 0.2
        
        iDLabel.adjustsFontSizeToFitWidth = true
        iDLabel.minimumScaleFactor = 0.2
        
        NatLabel.adjustsFontSizeToFitWidth = true
        NatLabel.minimumScaleFactor = 0.2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
