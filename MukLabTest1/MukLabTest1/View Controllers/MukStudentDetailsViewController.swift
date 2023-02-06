//
//  MukStudentDetailsViewController.swift
//  MukLabTest1
//
//  Created by Mukhtar Yusuf on 2/1/21.
//  Copyright © 2021 Mukhtar Yusuf. All rights reserved.
//

import UIKit
import CoreData

class MukStudentDetailsViewController: UITableViewController {

    // MARK: Outlets
    @IBOutlet weak var mukNameTextField: UITextField!
    @IBOutlet weak var mukAgeTextField: UITextField!
    @IBOutlet weak var mukTuitionTextField: UITextField!
    @IBOutlet weak var mukStartDateTextField: UITextField!
    
    // MARK: Properties
    var mukCoreDataStack: CoreDataStack!
    var mukSelectedStudent: MukStudent?
    lazy var mukDateFormatter: DateFormatter = {
        let mukDateFormatter = DateFormatter()
        mukDateFormatter.dateStyle = .short
        mukDateFormatter.timeStyle = .none
        mukDateFormatter.dateFormat = "dd/MM/yyyy"
        
        return mukDateFormatter
    }()
    
    @IBAction func mukDone(_ sender: UIBarButtonItem) {
        var mukStudent: MukStudent
        
        if let mukSelectedStudent = mukSelectedStudent {
            mukStudent = mukSelectedStudent
        } else {
            mukStudent = MukStudent(context: mukCoreDataStack.managedContext)
        }
        
        var mukIsValid = true
        var mukMessage = ""
        if let mukName = mukNameTextField.text, !mukName.isEmpty {
            mukStudent.mukName = mukName
        } else {
            mukIsValid = false
            mukMessage = "Please Enter a Name!"
        }
        if let mukAgeString = mukAgeTextField.text,
            let mukAge = Int32(mukAgeString) {
            mukStudent.mukAge = mukAge
        } else {
            mukIsValid = false
            mukMessage += "\nPlease Enter a valid age number!"
        }
        if let mukTuitionString = mukTuitionTextField.text,
            let mukTuition = Double(mukTuitionString) {
            mukStudent.mukTuition = mukTuition
        } else {
            mukIsValid = false
            mukMessage += "\nPlease Enter a valid tuition decimal!"
        }
        if let mukDateString = mukStartDateTextField.text,
            let mukDate = mukDateFormatter.date(from: mukDateString) {
            mukStudent.mukTermStartDate = mukDate
        } else {
            mukIsValid = false
            mukMessage += "\nPlease Enter a valid date format (dd/mm/yyyy)!"
        }
        
        if mukIsValid {
            mukCoreDataStack.saveContext()
            self.navigationController?.popViewController(animated: true)
        } else {
            mukShowAlert(mukMessage: mukMessage)
        }
    }
    
    // MARK: Utilities
    func mukShowAlert(mukMessage: String) {
        let mukAlert = UIAlertController(title: mukMessage,
                                         message: nil,
                                         preferredStyle: .alert)
        let mukAction = UIAlertAction(title: "Ok", style: .default)
        mukAlert.addAction(mukAction)
        
        present(mukAlert, animated: true)
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Student"
        
        if let mukSelectedStudent = mukSelectedStudent {
            title = "Edit Student"
            
            mukNameTextField.text = mukSelectedStudent.mukName
            mukAgeTextField.text = "\(mukSelectedStudent.mukAge)"
            mukTuitionTextField.text = "\(mukSelectedStudent.mukTuition)"
            mukStartDateTextField.text = mukDateFormatter.string(from: mukSelectedStudent.mukTermStartDate)
        }
    }
}
