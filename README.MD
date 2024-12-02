
## ![Wand 🪄](https://github.com/El-Machine/Wand/raw/main/App/Assets.xcassets/AppIcon.appiconset/magic-wand-transformed-20.png) API for Any (thing) |

### Swift Package Collection
[📦 |Packages](https://raw.githubusercontent.com/El-Machine/wand/main/collection.json)  

### Packages
[🔖 |CoreLocation](https://github.com/El-Machine/Wand_CoreLocation)   
[🏃 |CoreMotion](https://github.com/El-Machine/Wand_CoreMotion)   
[📡 |CoreNFC](https://github.com/El-Machine/Wand_CoreNFC)   
[🏛️ |Foundation](https://github.com/El-Machine/Wand_Foundation)   
[🌤️ |Weather](https://github.com/El-Machine/Wand_Weather)   
[🖥️ |URL](https://github.com/El-Machine/WandURL)    

### ⚙️ Usage

```bash

#Request current Location
|{ (location: CLLocation) in 

}

#Request .authorizedAlways permissions once
CLAuthorizationStatus.authorizedAlways | .one { status in
            
}
```

**📦 An ideal API acts as the [black box](https://wikipedia.org/wiki/Blackbox)**  
**⚡️ It’s possible to incapsulate whole data receiving and memory managment duty to one symbol**  
**?**   

[Medium.com](https://medium.com/@al.kozin/universal-api-7ddc67bb0aa5)
[YouTube.com](https://www.youtube.com/playlist?list=PLvprpeoOl6IoZ67BcD-t0rS1L5c5J4lPh)
[Habr.com](https://habr.com/ru/post/674010/)
  
>In Unix-like computer operating systems, a [pipeline](https://wikipedia.org/wiki/Pipeline_(Unix)) is a mechanism for inter-process communication using message passing. A pipeline is a set of processes chained together by their standard streams, so that the output text of each process (stdout) is passed directly as input (stdin) to the next one. The second process is started as the first process is still executing, and they are executed concurrently.

```bash
command1 | command2 | command3

ls -l | grep key | less
```


### ⚙️ Usage

```bash

#Request current Location
|{ (location: CLLocation) in 

}

#Request .authorizedAlways permissions once
CLAuthorizationStatus.authorizedAlways | .one { status in
            
}

#Update Pedometer Data
|{ (data: CMPedometerData) in 

}

#Scan for Bluetooth Peripheral
|{ (peripheral: CBPeripheral) in 

}

#Wait for a Notification
UIWindow.keyboardWillShowNotification | { (n: Notification) in
            
}

#Enumerate Contacts
CNContact.predicateForContacts(matchingName: "John") | .every { (contact: CNContact) in
                        
}

#Scan a tag
|.every { (tag: NFCNDEFTag) in

}

#Perform Face Observation
URL(string: "http://example.com/image.jpg") | { (faces: [VNFaceObservation]) in

}

#Perform Pose Observation
data | .while { (bodies: [VNHumanBodyPoseObservation]) in
    bodies < 2
}

#Detect shake
|{ (motion: UIEvent.EventSubtype) in
    if motion == .motionShake {
                
    }
}

```

```bash
#Customization
let wand = |{ (hands: [VNHumanHandPoseObservation]) in

}

let request: VNDetectHumanHandPoseRequest = wand.obtain()
request.maximumHandCount = 4

let preview: AVCaptureVideoPreviewLayer = wand.obtain()
view.layer.addSublayer(preview!)
```

### 💡 Idea
  Imagine that you have the black box that can give you an ```Any``` object.   
  You don't know what's already in the box or what will happen inside   
      
  Ask for object that you need |

### 🪄 Сoncept

Wand started from the idea about receiving anything in most efficient way. 
  
Add one sign to completion handler and retreive the result 📦   
ex [Pipe](https://github.com/El-Machine/Pipe)   
ex [API](https://github.com/El-Machine/iOS-API-Wrapper)   

[Feel free to contribute. You are welcome 🔬](https://github.com/El-Machine/Wand/graphs/contributors)

### 📚 Books

- 🖼️  Design Patterns: Elements of Reusable Object-Oriented Software (1994)   
      GOF: Erich Gamma, Richard Helm, Ralph Johnson, and John Vlissides

- 🧼  Clean Code: A Handbook of Agile Software Craftsmanship (2008)   
      Robert C. Martin  

- 🎼  Introduction to TRIZ. Basic Concepts and Approaches (2015)   
      G.S. Altshuller  

- 🏛️  Clean Architecture: A Craftsman's Guide to Software Structure and Design (2017)   
      Robert C. Martin  

- 😜  The Inmates Are Running the Asylum:   
      Why High Tech Products Drive Us Crazy and How to Restore the Sanity (2019)   
      Alan Cooper (Author)  

- ⊶  Origin (2017)   
      Dan Brown

## [🤝 Inspirtation](https://github.com/El-Machine/Wand/blob/main/INSPIRATION.TXT)

- 💿  CD Production   
      Sony Digital Audio Disk Corporation   
      ソニー・グループ株式会社   
      https://sony.com

- 🪟  Windows Production   
      Stan Barnes, William and Lynne Jolitz   
      https://support.microsoft.com/windows

- 📱  iPod   
      Tony Fadell   
      [ˈaɪˌpɔd]   
      https://wikipedia.org/wiki/Tony_Fadell

- 🍏  Apple   
      Steven Paul Jobs   
      A prominent part of macOS's original brand identity was   
      the use of Roman numeral X, pronounced "ten"   
      https://wikipedia.org/wiki/Steve_Jobs

- ⚙️  BSD   
      Berkeley, 1974   
      https://wikipedia.org/wiki/BSD

- 🔔  The concept of pipelines was championed by Douglas McIlroy at Unix's   
      Bell Labs   
      https://wikipedia.org/wiki/Pipeline_(Unix)

- |   Wand icon   
      Freepik - Flaticon   
      https://flaticon.com/free-icons/wand

- 🤖  Upscaled by AI   
      Augmented Intelligence   
      https://www.google.com?q=ai+upscale+image
    
- ⚡️  Macromedia® Flash   
      600 Townsend Street, San Francisco, CA 94103 1997   
      Now vector-based interactive web animations, buttons, and graphics   
      can be used on every Web page   
      https://wikipedia.org/wiki/Macromedia

- 🐢  Logo   
      Bolt, Beranek and Newman 1967   
      The language was conceived to teach concepts of programming related to Lisp   
      and only later to enable what Papert called "body-syntonic reasoning", where   
      students could understand, predict, and reason about the turtle's motion by   
      imagining what they would do if they were the turtle.   
      https://wikipedia.org/wiki/Logo_(programming_language)

- 🐬  Flipper   
      Anna Prosvetova, Pavel Zhovner   
      Flipper Zero is a portable multi-tool for pentesters and hardware geeks   
      in a toy-like body. It loves to explore the digital world around:   
      radio protocols, access control systems, hardware, and more.   
      https://flipperzero.one

## Tasks

- [x] Contacts
- [x] CoreLocation
- [x] CoreMotion
- [x] NSNotification
- [ ] CoreNFC
- [ ] Vision
- [ ] Rest
- [ ] MultipeerConnectivity

[Alex Kozin](mailto:al@el-machine.com)   
[El Machine 🤖](https://el-machine.com)  
App since 2008
