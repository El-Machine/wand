//
//  Repo+API.swift
//  PipeTests
//
//  Created by Alex Kozin on 24.03.2023.
//

import CloudKit

//GET
//https://jsonplaceholder.typicode.com/posts/1
@discardableResult
func |(id: Int,
       get: Ask<CKRecord>.Get) -> Pipe {

    let pipe = Pipe(object: id)
    guard pipe.ask(for: get) else {
        return pipe
    }
    
    let o: CKFetchRecordsOperation = pipe.get()
    
    let database: CKDatabase = pipe.get()
    database.add(o)
    
    return pipe
}

//POST
//https://jsonplaceholder.typicode.com/posts
@discardableResult
func | (postItem: CloudKit.Model,
        post: Ask<CKRecord>.Post) -> Pipe {

    let pipe = postItem.pipe
    guard pipe.ask(for: post) else {
        return pipe
    }
    
    pipe.put(try! CKRecordEncoder().encode(postItem) as [CKRecord]?)

    let o: CKModifyRecordsOperation = pipe.get()
    o.modifyRecordsResultBlock = { result in
        
        switch result {
            
            case .success():
                pipe.put(postItem)
            
            case .failure(let e):
                pipe.put(e)
            
        }
        
    }
    
    
    let database: CKDatabase = pipe.get()
    database.add(o)

    return pipe
}

////PUT
////https://jsonplaceholder.typicode.com/posts/42
//@discardableResult
//func | (postItem: JSONplaceholderAPI.Post,
//        put: Ask<JSONplaceholderAPI.Post>.Put) -> Pipeline {
//
//    let pipe = postItem.pipe
//
//    let path = JSONplaceholderAPI.Post.path + "/\(postItem.id)"
//    pipe.store(path)
//
//    pipe.store(Rest.Method.PUT)
//
//    var body: [String: any Hashable] = ["id": postItem.id]
//    if let title = postItem.title {
//        body["title"] = title
//    }
//    if let content = postItem.body {
//        body["body"] = content
//    }
//
//    pipe.store(body| as Data)
//
//    return pipe | put
//}
//
////DELETE
////https://jsonplaceholder.typicode.com/posts/42
//@discardableResult
//func | (postItem: JSONplaceholderAPI.Post,
//        delete: Ask<JSONplaceholderAPI.Post>.Delete) -> Pipeline {
//
//    let pipe = postItem.pipe
//
//    let path = JSONplaceholderAPI.Post.path + "/\(postItem.id)"
//    pipe.store(path)
//
//    pipe.store(Rest.Method.DELETE)
//
//    return pipe | delete
//}
