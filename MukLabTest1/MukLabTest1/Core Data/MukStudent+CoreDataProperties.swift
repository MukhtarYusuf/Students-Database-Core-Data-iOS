//
//  MukStudent+CoreDataProperties.swift
//  MukLabTest1
//
//  Created by Mukhtar Yusuf on 2/1/21.
//  Copyright © 2021 Mukhtar Yusuf. All rights reserved.
//
//

import Foundation
import CoreData


extension MukStudent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MukStudent> {
        return NSFetchRequest<MukStudent>(entityName: "MukStudent")
    }

    @NSManaged public var mukName: String
    @NSManaged public var mukAge: Int32
    @NSManaged public var mukTuition: Double
    @NSManaged public var mukTermStartDate: Date

}
