//
//  Repo+API.swift
//  PipeTests
//
//  Created by Alex Kozin on 24.03.2023.
//

import Foundation

import Pipe

extension JSONplaceholderAPI.Post: JSONplaceholderAPI.Model, Pipable {

    public static var path: String {
        base! + "posts"
    }

}

//GET
//https://jsonplaceholder.typicode.com/posts/1
@discardableResult
func |(id: Int,
       get: Ask<JSONplaceholderAPI.Post>.Get) -> Pipeline {

    let pipe = Pipeline()

    let path = JSONplaceholderAPI.Post.path + "/\(id)"
    pipe.store(path)

    pipe.store(Rest.Method.GET)

    return pipe | get
}

//GET
//https://jsonplaceholder.typicode.com/posts
@discardableResult
prefix func |(get: Ask<[JSONplaceholderAPI.Post]>.Get) -> Pipeline {

    let pipe = Pipeline()

    let path = JSONplaceholderAPI.Post.path
    pipe.store(path)

    pipe.store(Rest.Method.GET)

    return pipe | get
}

//POST
//https://jsonplaceholder.typicode.com/posts
@discardableResult
func | (postItem: JSONplaceholderAPI.Post,
        post: Ask<JSONplaceholderAPI.Post>.Post) -> Pipeline {

    let pipe = postItem.pipe

    let path = JSONplaceholderAPI.Post.path
    pipe.store(path)

    pipe.store(Rest.Method.POST)

    let body: Data = postItem|
    pipe.store(body)

    return pipe | post
}

//PUT
//https://jsonplaceholder.typicode.com/posts/42
@discardableResult
func | (postItem: JSONplaceholderAPI.Post,
        put: Ask<JSONplaceholderAPI.Post>.Put) -> Pipeline {

    let pipe = postItem.pipe

    let path = JSONplaceholderAPI.Post.path + "/\(postItem.id)"
    pipe.store(path)

    pipe.store(Rest.Method.PUT)

    var body: [String: any Hashable] = ["id": postItem.id]
    if let title = postItem.title {
        body["title"] = title
    }
    if let content = postItem.body {
        body["body"] = content
    }

    pipe.store(body| as Data)

    return pipe | put
}

//DELETE
//https://jsonplaceholder.typicode.com/posts/42
@discardableResult
func | (postItem: JSONplaceholderAPI.Post,
        delete: Ask<JSONplaceholderAPI.Post>.Delete) -> Pipeline {

    let pipe = postItem.pipe

    let path = JSONplaceholderAPI.Post.path + "/\(postItem.id)"
    pipe.store(path)

    pipe.store(Rest.Method.DELETE)

    return pipe | delete
}
