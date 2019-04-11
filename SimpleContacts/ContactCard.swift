//
//  ContactCard.swift
//  SimpleContacts
//
//  Created by james luo on 4/11/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import UIKit

class ContactCard: UITableViewCell {
@IBOutlet weak var ContactInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
