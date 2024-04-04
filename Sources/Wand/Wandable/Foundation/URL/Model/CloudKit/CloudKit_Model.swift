/// Copyright © 2020-2024 El Machine 🤖
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import CloudKit

public
struct CloudKit {
    
    typealias Model = CloudKit_Model
    
}

public
protocol CloudKit_Model: Model, Pipable {

    static var type: String {get}

    var id: String? {get set}

    var record: CKRecord? {get set}

    init(_ record: CKRecord)
    init(_ recordID: CKRecord.ID?)

    func updatedRecord() -> CKRecord
}

public
extension CloudKit_Model {

    static var type: String {
        Self.self|
    }

}


//GET
@discardableResult
func | <S, T: CloudKit.Model> (scope: S,
                               get: Ask<T>.Get) -> Pipe {

    let pipe = Pipe.attach(to: scope)
    guard pipe.ask(for: get) else {
        return pipe
    }

    pipe | .get { (record: CKRecord) in

        let model = T(record)
        pipe.put(model)

    }
    
    return pipe
}

//POST
//https://jsonplaceholder.typicode.com/posts
@discardableResult
func | <T: CloudKit.Model> (postItem: T,
                            post: Ask<T>.Post) -> Pipe {

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
