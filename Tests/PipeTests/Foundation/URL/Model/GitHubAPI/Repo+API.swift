//
//  Repo+API.swift
//  PipeTests
//
//  Created by Alex Kozin on 24.03.2023.
//

import Pipe

extension GitHubAPI.Repo: GitHubAPI.Model {

    public static var path: String {
        base! + "repositories"
    }

}

//https://api.github.com/repositories/42
@discardableResult
func |(id: Int,
       get: Ask<GitHubAPI.Repo>.Get) -> Pipe {

    let pipe = Pipe()

    let path = GitHubAPI.Repo.path + "/\(id)"
    pipe.store(path)
    pipe.store(Rest.Method.GET)

    return pipe | get
}

//https://api.github.com/repositories
@discardableResult
prefix func |(get: Ask<[GitHubAPI.Repo]>.Get) -> Pipe {

    let pipe = Pipe()

    let path = GitHubAPI.Repo.path
    pipe.store(path)

    pipe.store(Rest.Method.GET)

    return pipe | get
}

//https://api.github.com/repositories?q=ios
@discardableResult
func |(query: String,
       get: Ask<[GitHubAPI.Repo]>.Get) -> Pipe {

    let pipe = Pipe()

    let path = GitHubAPI.Repo.path + "?q=\(query)"
    pipe.store(path)

    pipe.store(Rest.Method.GET)

    return pipe | get
}
