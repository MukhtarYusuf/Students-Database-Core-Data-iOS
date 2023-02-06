//
//  MukStudentCell.swift
//  MukLabTest1
//
//  Created by Mukhtar Yusuf on 2/1/21.
//  Copyright © 2021 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukStudentCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var mukNameLabel: UILabel!
    @IBOutlet weak var mukAgeLabel: UILabel!
    @IBOutlet weak var mukTuitionLabel: UILabel!
    @IBOutlet weak var mukStartDateLabel: UILabel!
    
    // MARK: Properties
    lazy var mukDateFormatter: DateFormatter = {
        let mukDateFormatter = DateFormatter()
        mukDateFormatter.dateStyle = .medium
        mukDateFormatter.timeStyle = .none
        
        return mukDateFormatter
    }()
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Utilities
    func configure(with mukStudent: MukStudent) {
        mukNameLabel.text = "\(mukStudent.mukName)"
        mukAgeLabel.text = "\(mukStudent.mukAge)"
        mukTuitionLabel.text = String(format: "$%.2f, ", mukStudent.mukTuition)
        mukStartDateLabel.text = "\(mukDateFormatter.string(from: mukStudent.mukTermStartDate))"
    }
}
