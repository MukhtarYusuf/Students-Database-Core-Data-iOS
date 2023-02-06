//
//  MukStudentListViewController.swift
//  MukLabTest1
//
//  Created by Mukhtar Yusuf on 1/31/21.
//  Copyright © 2021 Mukhtar Yusuf. All rights reserved.
//

import UIKit
import CoreData

class MukStudentListViewController: UITableViewController {
    
    // MARK: Properties
    var mukCoreDataStack: CoreDataStack! {
        didSet {
            NotificationCenter.default.addObserver(forName:
                    Notification.Name.NSManagedObjectContextObjectsDidChange,
                                                       object: mukManagedObjectContext,
                                                       queue: OperationQueue.main)
            { [weak self] notification in
                if self?.isViewLoaded ?? false { // No need?
                    self?.mukLoadStudents()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    lazy var mukManagedObjectContext: NSManagedObjectContext = {
        return mukCoreDataStack.managedContext
    }()
    var mukStudents: [MukStudent] = []
    
    // MARK: UITableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mukStudents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mukIdentifier = MukTableViewCellIdentifiers.mukStudentCell
        let mukCell = tableView.dequeueReusableCell(withIdentifier: mukIdentifier,
                                                 for: indexPath) as! MukStudentCell
        let mukStudent = mukStudents[indexPath.row]
        mukCell.configure(with: mukStudent)
        
        return mukCell
    }
    
    // MARK: UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mukCell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "EditStudent", sender: mukCell)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mukStudent = mukStudents[indexPath.row]
            mukManagedObjectContext.delete(mukStudent)
            mukCoreDataStack.saveContext()
            
//            mukLoadStudents()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddStudent"  || segue.identifier == "EditStudent" {
            if let mukStudentDetailVC = segue.destination as? MukStudentDetailsViewController {
                mukStudentDetailVC.mukCoreDataStack = mukCoreDataStack
                
                if let mukCell = sender as? MukStudentCell,
                    let mukIndex = tableView.indexPath(for: mukCell)?.row {
                    mukStudentDetailVC.mukSelectedStudent = mukStudents[mukIndex]
                }
            }
        }
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 125
        let mukNib = UINib(nibName: MukTableViewCellIdentifiers.mukStudentCell,
                           bundle: nil)
        tableView.register(mukNib, forCellReuseIdentifier:
            MukTableViewCellIdentifiers.mukStudentCell)
        
        mukLoadStudents()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Utilities
    private func handleFetchError(error: NSError) {
        print("Fetching Error \(error), \(error.userInfo)")
    }
    
    private func mukLoadStudents() {
        let mukFetchRequest: NSFetchRequest<MukStudent> = MukStudent.fetchRequest()
        do {
            try mukStudents = mukManagedObjectContext.fetch(mukFetchRequest)
        } catch let error as NSError {
            handleFetchError(error: error)
        }
    }
    
    struct MukTableViewCellIdentifiers {
        static let mukStudentCell = "MukStudentCell"
    }
}
