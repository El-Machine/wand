//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CloudKit

extension CKModifyRecordsOperation: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        

        let records: [CKRecord] = pipe.get()!

        let operation = CKModifyRecordsOperation(recordsToSave: records)

        operation.configuration = pipe.get()

        return operation as! Self   
    }

}
