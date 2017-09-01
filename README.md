![](https://img.shields.io/badge/swift-3.0.1-green.svg)

# SonogramView
Audio visualisation of song

# HOWTO:
Try it in Playground! :)

```Swift
import PlaygroundSupport

var fileUrl: URL?
do {
    fileUrl = PlaygroundSupport.playgroundSharedDataDirectory.appendingPathComponent("test.m4a")
    // User/Documents/Shared Playground Data
} catch {
    print(error)
}


var waveView: SonogramView = SonogramView()
waveView.addDurationOfFileWith(url: fileUrl!)
waveView.convertToPoints()
// And you are done!

// Customization of view
waveView.backgroundColor = .clear
let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
view.backgroundColor = .white
view.addSubview(waveView)

waveView.frame.size.width = view.frame.width
waveView.frame.size.height = view.frame.height
waveView.center = view.center

PlaygroundPage.current.liveView = view // Showing in liveView with xCode Playground
```
