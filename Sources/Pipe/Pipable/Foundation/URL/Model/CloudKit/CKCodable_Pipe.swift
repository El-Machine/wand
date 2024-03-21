//
//  CKCodable_Pipe.swift
//  gym
//
//  Created by al on 12.03.2024.
//

import CloudKit.CKRecord

func | <T: CloudKit.Model> (records: [CKRecord], completion: ([T])->() ) {

    completion(records.map {
        .init($0)
    })

}
