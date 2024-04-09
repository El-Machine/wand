//
//  Repo+API.swift
//  PipeTests
//
//  Created by Alex Kozin on 24.03.2023.
//

import CloudKit

//GET
//Fetch for Record.ID
@discardableResult
func |<S>(scope: S,
          get: Ask<CKRecord>.Get) -> Pipe {

    let pipe = Pipe.attach(to: scope)
    guard pipe.ask(for: get) else {
        return pipe
    }
    
    let o: CKFetchRecordsOperation = pipe.get()
    
    let database: CKDatabase = pipe.get()
    database.add(o)
    
    return pipe
}

//GET
//Query with predicate
@discardableResult
func |<S>(scope: S,
       get: Ask<[CKRecord]>.Get) -> Pipe {

    let pipe = Pipe.attach(to: scope)
    guard pipe.ask(for: get) else {
        return pipe
    }

    let o: CKQueryOperation = pipe.get()

    let database: CKDatabase = pipe.get()
    database.add(o)

    return pipe
}
