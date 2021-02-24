![Pipe](logo.png?raw=true "Title")

```swift
//Anything from Something
let anything: Anything = something|

//Anything from Nothing
|{ (anything: Anything) in

}
```
### Idea
Just imagine that you have a pipe and look into it from your side  
You don't know what is already in pipe or what will happen on another side of pipe   
Simply get objects that you need on your side

### Usage

To receive object that you need from something else, just add Pipe sign after it |
```swift
let int: Int = true|

let double: Double = false|

let float: CGFloat = true|

```

```swift
let point: CGPoint = (50, 200)|

let size: CGSize = (50, 200)|

let rect: CGRect = (50, 50, 200, 200)|

let insets: UIEdgeInsets = (50, 50, 200, 200)|
```

Or start waiting for object with Pipe sign | and completion
```swift
|{ (location: CLLocation) in

}

|{ (event: CMPedometerEvent) in

}

|{ (data: CMPedometerData) in

}

|{ (peripheral: CBPeripheral) in

}
```

Close Pipe adding sign | at the beginning
 ```swift
 |piped
 ```

### Сoncept

Pipe started from idea about receiving anything in most efficient and fast way  
Just add one sign to completion and start receiving the result  
Current implementation is not final solution, but main idea

You ideas, comments, contribution are welcome  
Main course is to add some new Pipable extensions for other types and add some features for piping any Pipable types between
