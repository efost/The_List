//
//  CloudKitHelper.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 23/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

// MARK: - notes
// good to read: https://www.hackingwithswift.com/read/33/overview
//
// important setup in CloudKit Dashboard:
//
// https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset
// https://www.hackingwithswift.com/read/33/5/a-hands-on-guide-to-the-cloudkit-dashboard
//
// On your device (or in the simulator) you should make sure you are logged into iCloud and have iCloud Drive enabled.

struct CloudKitHelper {
    
    // MARK: - record types
    struct RecordType {
        static let ListItem = "ListItem"
    }
    
    // MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: - saving to CloudKit
    static func save(item: ListItem, completion: @escaping (Result<ListItem, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.ListItem)
        itemRecord["name"] = item.name
        itemRecord["address"] = item.address
        itemRecord["city"] = item.city
        itemRecord["category"] = item.category.rawValue
        itemRecord["done"] = item.done
        itemRecord["notes"] = item.notes
        
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                let recordID = record.recordID
                guard let name = record["name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                let listItem = ListItem (
                    recordID: recordID,
                    name: name,
                    address: record["address"],
                    city: record["city"],
                    category: ListItem.Category(rawValue: record["category"] as! String)!,
                    done: record["done"]!,
                    notes: record["notes"]
                )
                completion(.success(listItem))
            }
        }
    }
    
    // MARK: - fetching from CloudKit
    static func fetchAll(completion: @escaping (Result<ListItem, Error>) -> ()) {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let query = CKQuery(recordType: RecordType.ListItem, predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "address", "city", "category", "done", "notes"]
        operation.resultsLimit = 50
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let category = ListItem.Category(rawValue: record["category"] as! String) else { return }
                guard let done = record["done"] as? Bool else { return }
                let listElement = ListItem(
                    recordID: recordID,
                    name: name,
                    address: record["address"],
                    city: record["city"],
                    category: category,
                    done: done,
                    notes: record["notes"]
                )
                completion(.success(listElement))
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
//                guard let cursor = cursor else {
//                    completion(.failure(CloudKitHelperError.cursorFailure))
//                    return
//                }
//                print("Cursor: \(String(describing: cursor))")
            }
            
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
     
    static func fetchOne(item: ListItem, completion: @escaping (Result<ListItem, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    DispatchQueue.main.async {
                        completion(.failure(err))
                    }
                    return
                }
                guard let record = record else {
                    DispatchQueue.main.async {
                        completion(.failure(CloudKitHelperError.recordFailure))
                    }
                    return
                }
                guard let name = record["name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                let listItem = ListItem(
                    recordID: recordID,
                    name: name,
                    address: record["address"],
                    city: record["city"],
                    category: ListItem.Category(rawValue: record["category"] as! String)!,
                    done: record["done"]!,
                    notes: record["notes"]
                )
                completion(.success(listItem))
            }
        }
    }
    
    // MARK: - modify in CloudKit
    static func modify(item: ListItem, completion: @escaping (Result<ListItem, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            record["name"] = item.name as CKRecordValue
            record["done"] = item.done ? 1 : 0

            CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        completion(.failure(err))
                        return
                    }
                    guard let record = record else {
                        completion(.failure(CloudKitHelperError.recordFailure))
                        return
                    }
                    let recordID = record.recordID
                    guard let name = record["name"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    let listItem = ListItem(
                        recordID: recordID,
                        name: name,
                        address: record["address"],
                        city: record["city"],
                        category: ListItem.Category(rawValue: record["category"] as! String)!,
                        done: record["done"]!,
                        notes: record["notes"]
                    )
                    completion(.success(listItem))
                }
            }
        }
    }
}
