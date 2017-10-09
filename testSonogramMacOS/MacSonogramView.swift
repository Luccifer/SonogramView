// Eyerise
// Gleb Karpushkin
// Moscow, Russian Federation
// 1 Sep 2017

import AppKit
import Accelerate
import AVFoundation

struct readFile {
    static var arrayFloatValues: [Float] = []
    static var points: [CGFloat] = []
}

class MacSonogramView: NSView {
    
    @IBInspectable var sonogramColor: NSColor = NSColor(red: 212.0/255.0, green: 216.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    @IBInspectable var shapeColor: NSColor = NSColor(red: 232/255, green: 59/255, blue: 86/255, alpha: 1.0)
    @IBInspectable var animationFromColor: NSColor = NSColor(red: 212.0/255.0, green: 216.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    @IBInspectable var animationToColor: NSColor = NSColor.red
    
    var shapeLayer: CAShapeLayer!
    var duration: Double = 0
    override var isFlipped: Bool {
        return true
    }
    
    // override draw
    
    override func draw(_ rect: CGRect) {
        drawMyView(rect: rect)
    }
    
    // MARK: public API
    
    func addDurationOfFileWith(url: URL) {
        do {
            let file = try AVAudioFile(forReading: url)
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
            
            let recAsset = AVAsset(url: url)
            duration = recAsset.duration.seconds
            
            let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(file.length))!
            try file.read(into: buf)
            readFile.arrayFloatValues = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
        } catch {
            print(error)
        }
    }
    
    // MARK: private API
    
    private func drawMyView(rect: CGRect) {
        convertToPoints()
        var f = 0
        let aPath = NSBezierPath()
        
        aPath.lineWidth = 2.0
        
        aPath.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        
        var i = 0
        
        let allDistance = self.frame.size.width
        let countOfIntervals = Int(allDistance / 2.5)
        
        let max = readFile.points.max()
        let koeff = 20 / max!
        var interval = 1
        
        if readFile.points.count > countOfIntervals {
            interval = Int(readFile.points.count / countOfIntervals)
        }
        
        _ = readFile.points.map { _ in
            if i % interval == 0 {
                var x:CGFloat = 2.5
                aPath.move(to: CGPoint(x:aPath.currentPoint.x + x , y:aPath.currentPoint.y))
                aPath.line(to: NSPoint(x: aPath.currentPoint.x, y: aPath.currentPoint.y - (readFile.points[f] * koeff) - 1.0))
                aPath.close()
                x += 1
                f += 1
            }
            i += 1
        }
        
        sonogramColor.set()
        aPath.lineJoinStyle = .roundLineJoinStyle
        aPath.stroke()
        aPath.fill()
        
        let animation2 = CABasicAnimation(keyPath: "strokeColor")
        animation2.duration = 10
        animation2.fromValue = animationFromColor
        animation2.toValue = animationToColor
        
        shapeLayer = CAShapeLayer()
        shapeLayer.anchorPoint = NSPoint(x: 0.5, y: 0.5)
        shapeLayer.add(animation2, forKey: "coloring")
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineWidth = 2
        shapeLayer.frame.size.width = self.frame.width
        shapeLayer.frame.size.height = 30
        shapeLayer.path = aPath.cgPath
        
        wantsLayer = true
        
    }
    
    private func convertToPoints() {
        var processingBuffer = [Float](repeating: 0.0,
                                       count: Int(readFile.arrayFloatValues.count))
        let sampleCount = vDSP_Length(readFile.arrayFloatValues.count)
        
        vDSP_vabs(readFile.arrayFloatValues, 1, &processingBuffer, 1, sampleCount);
        
        let multipler = 1
        
        let samplesPerPixel = 150 * multipler
        
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                             count: Int(samplesPerPixel))
        let downSampledLength = Int(readFile.arrayFloatValues.count / samplesPerPixel)
        var downSampledData = [Float](repeating:0.0,
                                      count:downSampledLength)
        vDSP_desamp(processingBuffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
        
        readFile.points = downSampledData.map{CGFloat($0)}
    }
    
    private func readArray( array:[Float]){
        readFile.arrayFloatValues = array
    }
}

extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }
        
        return path
    }
}
