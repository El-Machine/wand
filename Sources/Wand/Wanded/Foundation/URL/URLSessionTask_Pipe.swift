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

import Foundation.NSURLSession

extension Pipe.Error {

    static func HTTP(_ reason: String) -> Error {
        Self(reason: reason)
    }

}

extension URLSessionDataTask: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let session: URLSession = pipe.get()
        let request: URLRequest = pipe.get()

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                pipe.put(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                pipe.put(Pipe.Error.HTTP("Not http?"))
                return
            }
            

            let statusCode = httpResponse.statusCode
            if !(200...299).contains(httpResponse.statusCode)  {
                pipe.put(Pipe.Error.HTTP("Code: \(statusCode)"))
                return
            }           

            let mime = httpResponse.mimeType
            if mime != "application/json" {
                pipe.put(Pipe.Error.HTTP("Mime: \(mime ?? "")"))
                return
            }

            guard let data = data else {
                pipe.put(Pipe.Error.HTTP("No data"))
                return
            }

            pipe.put(httpResponse)
            pipe.put(data)
        } as! Self

        return pipe.put(task)
    }

}
