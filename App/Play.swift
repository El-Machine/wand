///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) .LICENSE
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Created by Alex Kozin
/// 2020 El Machine

import SwiftUI

@available(iOS 14, macOS 12, tvOS 14, watchOS 7, *)
@main
struct PlayApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}

@available(iOS 14, macOS 12, tvOS 14, watchOS 7, *)
struct ContentView: View {
    var body: some View {

        VStack {
            Image(systemName: "wand.and.stars")
            Text("Hello, world!")
        }
        .padding()

    }
}

@available(iOS 14, macOS 12, tvOS 14, watchOS 7, *)
#Preview {
    ContentView()
}
