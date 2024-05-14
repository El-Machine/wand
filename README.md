
<picture>
    <source srcset="./App/Assets.xcassets/AppIcon.appiconset/magic-wand-transformed-64.png" media="(prefers-color-scheme: dark)" alt="Wand 🪄">
    <img src="./App/Assets.xcassets/AppIcon.appiconset/magic-wand-transformed-64.png" alt="Wand 🪄">
</picture>

## API for Any (thing) |
**An ideal API acts as a black box 📦**  
**It’s possible to incapsulate whole data receiving and memory managment into one symbol?**  
[Medium.com](https://medium.com/@al.kozin/universal-api-7ddc67bb0aa5)
[Habr.com](https://habr.com/ru/post/674010/)

>In Unix-like computer operating systems, a [pipeline](https://en.wikipedia.org/wiki/Pipeline_(Unix)) is a mechanism for inter-process communication using message passing. A pipeline is a set of processes chained together by their standard streams, so that the output text of each process (stdout) is passed directly as input (stdin) to the next one. The second process is started as the first process is still executing, and they are executed concurrently.

```bash
command1 | command2 | command3

ls -l | grep key | less
```

### Swift
```bash
#Create handler  
{ (foo: Foo) in

}

```

```bash
#Black box
prefix func | (handler: @escaping (Foo)->() )

#Call API
| { (foo: Foo) in

}

```

```bash
#Retreive data (profit)
handler(foo)

``` 

### Usage

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
CNContact.predicateForContacts(matchingName: "John Appleseed") | .every { (contact: CNContact) in
                        
}

#Scan a tag
| .every { (tag: NFCNDEFTag) in

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

```swift
#Customization
let wand = |{ (hands: [VNHumanHandPoseObservation]) in

}

let request: VNDetectHumanHandPoseRequest = wand.obtain()
request.maximumHandCount = 4

let preview: AVCaptureVideoPreviewLayer = wand.obtain()
view.layer.addSublayer(preview!)

```
### Idea
  Imagine that you have a black box that can give you any object 💡  
  You don't know what is already in box or what will happens inside ⚙️   
  Simply ask for objects that you need

### Сoncept

Wand started from idea about receiving anything in most efficient and fast way 🪄  
Just add on¯e sign to completion handler and retreive the result 📦  

You ideas, comments, contribution are welcome |

## Credits

<a href="https://www.flaticon.com/free-icons/wand" title="wand icons">
            
![Wand 🪄](https://github.com/El-Machine/Wand/raw/main/App/Assets.xcassets/AppIcon.appiconset/magic-wand-transformed-16.png)
Wand icon created by Freepik - Flaticon
            
</a>

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
Mobile Apps since 2008
