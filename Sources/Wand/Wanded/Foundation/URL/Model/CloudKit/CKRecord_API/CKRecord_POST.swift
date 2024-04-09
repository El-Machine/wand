//
//  Repo+API.swift
//  PipeTests
//
//  Created by Alex Kozin on 24.03.2023.
//

import CloudKit

//POST
//Post item
@discardableResult
func | (postItem: CloudKit.Model,
        post: Ask<CKRecord>.Post) -> Pipe {

    let pipe = postItem.pipe
    guard pipe.ask(for: post) else {
        return pipe
    }
    
    pipe.store([postItem.updatedRecord()])

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
