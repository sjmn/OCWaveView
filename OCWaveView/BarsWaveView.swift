//
//  SimpleWaveView.swift
//  OCWaveView
//
//  Created by Emannuel Carvalho on 17/03/17.
//  Copyright © 2017 OC. All rights reserved.
//

import UIKit

@IBDesignable
public class BarsWaveView: UIView {
    
    /// The color of the bars in the view
    @IBInspectable public var color: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    
    /// The width of each bar
    @IBInspectable public var lineWidth: CGFloat = 0.0
    
    /// The amplitude to multiply the size of the bars
    @IBInspectable public var amplitude: CGFloat = 0.0
    
    /// The value to be used in the senoid function
    @IBInspectable
    public var value: CGFloat = 200 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    private var spin1 = 0.1
    private var spin2 = 0.6
    private var spin3 = 0.1
    
    private var signal1 = 1.0
    private var signal2 = 1.0
    private var signal3 = 1.0
    
    private func updateSpin() {
        
        let factor1 = 0.65
        let factor2 = 0.41
        let factor3 = 0.7
        
        if spin1 >= 1.0 {
            signal1 = -1.0
        } else if spin1 <= 0.1 {
            signal1 = 1.0
        }
        spin1 += signal1 * factor1
        
        if spin2 >= 1.0 {
            signal2 = -1.0
        } else if spin2 <= 0.1 {
            signal2 = 1.0
        }
        spin2 += signal2 * factor2
        
        if spin3 >= 1.0 {
            signal3 = -1.0
        } else if spin3 <= 0.1 {
            signal3 = 1.0
        }
        spin3 += signal3 * factor3
        
    }
    
    
    var s = 0.0
    
    override public func draw(_ rect: CGRect) {
        
        let height = frame.height/2
        
        let bowlSenoid = BowlSenoid(center: Double(frame.width)/2.0)
        bowlSenoid.s = s
        bowlSenoid.s += 0.5
        if bowlSenoid.s >= Double(frame.width) {
            bowlSenoid.s = 0.0
        }
        s = bowlSenoid.s
        
        var paths = [UIBezierPath]()
    
        updateSpin()
        
        let size = CGFloat(24)
        
        for x in 0...Int(frame.width/size) {
            let newX = CGFloat(x) * size
            let y = height + value * CGFloat(bowlSenoid.f(newX)) * 0.000008
            let path = UIBezierPath()
            print(y/3)
            path.move(to: CGPoint(x: newX, y: frame.height/2 - (amplitude * 10 + y)/10))
            path.addLine(to: CGPoint(x: newX, y: frame.height/2 + (amplitude * 10 + y)/10))
            paths.append(path)
        }
        
        color.set()
        for path in paths {
            path.lineCapStyle = .round
            path.lineWidth = lineWidth
            path.stroke()
        }
        
    }
    
}
