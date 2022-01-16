//
//  OfflineComments+CoreDataProperties.swift
//  TechTest
//
//  Created by Soumya Ammu on 1/13/22.
//
//

import Foundation
import CoreData


extension OfflineComments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineComments> {
        return NSFetchRequest<OfflineComments>(entityName: "OfflineComments")
    }
    
    

    @NSManaged public var name: String?
    @NSManaged public var comment: String?
    @NSManaged public var postID: Int16
    @NSManaged public var id: Int16

}

extension OfflineComments : Identifiable {

}
