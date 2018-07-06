//
//  ListNotesTableViewCell.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 10/18/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit

class ListTodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoTimeStampLabel: UILabel!
    @IBOutlet weak var todoDescriptionLabel: UILabel!
    @IBOutlet weak var todoCompleteButton: UIButton!
    var onButtonTouched: ((UITableViewCell) -> Void)? = nil
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        onButtonTouched?(self)
    }
    
}
