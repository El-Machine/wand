/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
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

import Wand

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
