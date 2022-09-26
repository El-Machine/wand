

![Pipe](logo.png?raw=true "Title")

### It’s possible to incapsulate whole data receiving process into one symbol?
[Medium.com](https://medium.com/@al.kozin/universal-api-7ddc67bb0aa5)
[Habr.com](https://habr.com/ru/post/674010/)

Declarate variable  
```swift
var a: Foo
```
Add one symbol 
```swift
*(a as Foo), Foo.self^, etc...
```
Receive data
```swift
a != nil
``` 

### Pipe is attempt to find an answer

>In Unix-like computer operating systems, a [pipeline](https://en.wikipedia.org/wiki/Pipeline_(Unix)) is a mechanism for inter-process communication using message passing. A pipeline is a set of processes chained together by their standard streams, so that the output text of each process (stdout) is passed directly as input (stdin) to the next one. The second process is started as the first process is still executing, and they are executed concurrently.

```bash
command1 | command2 | command3

ls -l | grep key | less
```

### Usage

```swift

//Anything from Something
let anything: Anything = something|

let i: Int = float|
let string: String = data|

let front: UIColor = 0x554292|
let back: UIColor? = "#554292"|

let found: Date? = "tomorrow at 8 UTC+4" | .date

//Anything from Nothing
|{ (anything: Anything) in
🧙🏼
}

|{ (location: CLLocation) in 

}

["CLLocationDistance": 125,
"CLLocationAccuracy": kCLLocationAccuracyBest] | .one { (location: CLLocation) in
            
}

|{ (data: CMPedometerData) in 

}

|{ (peripheral: CBPeripheral) in 

}

UIWindow.keyboardWillShowNotification | { (n: Notification) in
            
}

CNContact.predicateForContacts(matchingName: "John Appleseed") | .every { (contact: CNContact) in
                        
}

|{ (tag: NFCNDEFTag) in

}

URL(string: "http://example.com/image.jpg") | { (faces: [VNFaceObservation]) in

}

data | .while { (bodies: [VNHumanBodyPoseObservation]) in
    bodies < 2
}

//Detect shake
|{ (motion: UIEvent.EventSubtype) in
    if motion == .motionShake {
                
    }
}

//UIView.animate
(duration: 0.42, options: .allowUserInteraction) | {
    animationView.alpha = 0
}

```

```
//Customization
let pipe = |{ (hands: [VNHumanHandPoseObservation]) in

}

let request: VNDetectHumanHandPoseRequest = pipe.get()
request.maximumHandCount = 4

let preview: AVCaptureVideoPreviewLayer = pipe.get()
view.layer.addSublayer(preview!)

```
### Idea
Just imagine that you have a pipe and look into it from your side  
You don't know what is already in pipe or what will happens on another side of pipe   
Simply get objects that you need on your side

### Сoncept

Pipe started from idea about receiving anything in most efficient and fast way  
Just add one sign to completion handler and start receiving the result  
Current implementation is not final solution, but main idea

You ideas, comments, contribution are welcome  
Main course is to add some new Pipable extensions for other types
