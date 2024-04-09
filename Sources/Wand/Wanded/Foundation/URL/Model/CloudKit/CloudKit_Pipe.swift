//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CloudKit

extension CKContainer: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        Self.default() as! Self
    }

}

extension CKDatabase: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        let container: CKContainer = pipe.get()
        return container.publicCloudDatabase as! Self
    }

}

extension CKRecord.ID: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        
        if let int: Int = pipe.get() {
            return Self.init(recordName: int|)
        }
        
        return Self.init(recordName: pipe.get()!)
    }

}

extension CKOperation.Configuration: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let config = Self()
        config.isLongLived = true
        config.qualityOfService = .default

        return config
    }

}

extension CKQuery: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let q = CKQuery(
            recordType: pipe.get()!,
            predicate: pipe.get()!
        )

        q.sortDescriptors = pipe.get()
        return q as! Self
    }

}
