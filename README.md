![](https://img.shields.io/badge/swift-3.0.1-green.svg)

![](https://github.com/Luccifer/SonogramView/blob/master/Screen%20Shot%202017-09-01%20at%2023.35.47.png)

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
