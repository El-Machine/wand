//
//  Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 29.09.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

final class Pipe {
    
    //All pipes
    static var pipes = [String: Pipe]()
    
    //Piped objects
    var piped = [String: Any]()
    
    //Expectations of objects in pipe
    private(set) var expectations: Expectations?
    private(set) lazy var expect: Expectations = {
        expectations = Expectations(self)
        return expectations!
    }()
    
    //Get or create
    class func from(_ pipable: Pipable?) -> Pipe {
        pipable?.pipe() ?? Pipe()
    }
    
    //Close
    func close() {
        piped.removeAll()
        
        Pipe.pipes = Pipe.pipes.filter {
            $1 !== self
        }
        
        expectations = nil
    }
    
}

//Put to pipe
extension Pipe {
    
    @discardableResult
    func put<T>(_ object: T) -> T {
        Pipe.pipes[object|] = self
        piped[T.self|] = object
        
        if let sequence = object as? Array<Any> {
            sequence.forEach {
                Pipe.pipes[$0|] = self
            }
        }
        
        return object
    }
    
    @discardableResult
    func put<T>(_ create: ()->(T)) -> T {
        put(create())
    }
    
}

//Get from pipe
extension Pipe {
    
    func get<T>() -> T? {
        piped[String(describing: T.self)] as? T
    }
    
    func getOrCreate<T>(_ create: ()->(T)) -> T {
        get() ?? put(create())
    }
    
    func getOrCreate<T>(_ object: T) -> T {
        get() ?? put(object)
    }
    
}

//Welding
extension Pipe {
    
    @discardableResult
    func weld<T: Pipable>(with: T) -> T {
        guard let pipe = with.pipe() else {
            return self.put(with)
        }
        
        expectations?.merge(with: pipe.expectations)
        
        pipe.piped.forEach {
            put($0)
        }
        
        pipe.close()
        
        return with
    }
    
}
