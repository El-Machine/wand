//
//  Repo.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

struct Repo: GitHubAPIModel {

    let id: Int

    let name: String?
    let description: String?

    let watchers: Int?

    static func get<P>(with piped: P, on pipe: Pipe) {

        //api.github.com/repositories/42
        if let id = piped as? Int {

            let path = base + "repositories/" + id|
            pipe.put(path)

        }

    }

}

//extension [Repo]: GitHubAPIModel,
//
//                  Rest.Model,
//                  Expectable,
//                  ExpectableLabeled,
//                  ExpectableWithout {
//
//    public static func get<P>(with piped: P, on pipe: Pipe) {
//
//        switch piped {
//
//                //api.github.com/repositories?q=ios
//            case let query as String:
//
//                let path = base + "repositories?q=" + query
//                pipe.put(path)
//
//                break
//
//                //api.github.com/repositories
//            default:
//
//                let path = base + "repositories"
//                pipe.put(path)
//
//                break
//
//        }
//
//    }
//
//}

