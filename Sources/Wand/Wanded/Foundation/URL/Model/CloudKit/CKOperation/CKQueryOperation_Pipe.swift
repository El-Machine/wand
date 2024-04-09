//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CloudKit

extension CKQueryOperation: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let config: CKOperation.Configuration   = pipe.get()
        let query: CKQuery                      = pipe.get()

        let operation = CKQueryOperation(query: query)
        operation.configuration = config
        operation.cursor = pipe.get()

        var records = [CKRecord]()

        operation.recordMatchedBlock = { id, result in

            switch result {
                
                case .success(let record):
                    records.append(record)
                
                    //Ignore partial errors
//                case .failure(let e):
//                    pipe.put(e)

                default:
                    break

            }
            
        }

        operation.queryResultBlock = { result in

            switch result {

                case .success(let cursor):
                    pipe.put(records)
                    pipe.put(cursor)

                case .failure(let e):
                    pipe.put(e)

            }



        }

        return operation as! Self   
    }

}
