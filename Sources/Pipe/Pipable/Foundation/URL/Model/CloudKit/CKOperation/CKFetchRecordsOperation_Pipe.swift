//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CloudKit

extension CKFetchRecordsOperation: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        
        let id: CKRecord.ID = pipe.get()
        
        let config = CKOperation.Configuration()
        config.isLongLived = true
        config.qualityOfService = .default
        
        let operation = CKFetchRecordsOperation(recordIDs: [id])
        operation.configuration = config
        
        operation.perRecordResultBlock = { id, result in
            
            switch result {
                
                case .success(let record):
                    pipe.put(record)
                
                case .failure(let e):
                    pipe.put(e)
                
            }
            
        }
        
        return operation as! Self   
    }

}
