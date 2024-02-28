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
        
        let config = CKOperation.Configuration()
        config.isLongLived = true
        config.qualityOfService = .default
        
        let operation = CKModifyRecordsOperation(recordsToSave: pipe.get())
        operation.configuration = config
        
        return operation as! Self   
    }

}
