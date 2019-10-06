//
//  CardView.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 9/26/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class CardView: UIButton {
    
    // MARK: Internal types.
    enum Shape {
        case oval
        case diamond
        case squiggle
    }
    
    enum Shading {
        case open
        case striped
        case solid
    }
    
    // MARK: Stored properties.
    var numberOfObjects: Int? {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var shape: Shape? {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var shading: Shading?{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var color: UIColor?{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    

    
    //MARK: The function, where all actual drawing takes place.
    override func draw(_ rect: CGRect) {
        let cardsBackground = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.white.setFill()
        cardsBackground.fill()
        
        //MARK: Defining drawing margins for the shapes inside a card.
        let upperOrigin = CGPoint(x: cardsBackground.bounds.midX, y: (cardsBackground.bounds.midY - 49))
        let upperMidOrigin = CGPoint(x: cardsBackground.bounds.midX, y: (cardsBackground.bounds.midY - 30))
        let centerOrigin = CGPoint(x: cardsBackground.bounds.midX, y: (cardsBackground.bounds.midY - 15))
        let lowerMidOrigin = CGPoint(x: cardsBackground.bounds.midX, y: (cardsBackground.bounds.midY + 5))
        let lowerOrigin = CGPoint(x: cardsBackground.bounds.midX, y: (cardsBackground.bounds.midY + 19))
        
        func drawOval(in amounts: Int, of color: UIColor, with shading: Shading) {
            switch shape {
            case .oval:
                let oval = UIBezierPath()
                
                var numberOfElements: [CGPoint] {
                    get {
                        switch amounts {
                        case 1:
                            return [centerOrigin]
                        case 2:
                            return [upperMidOrigin, lowerMidOrigin]
                        case 3:
                            return [upperOrigin, centerOrigin, lowerOrigin]
                        default:
                            return []
                        }
                    }
                }
                
                for origin in numberOfElements {
                    oval.move(to: origin)
                    oval.addLine(to: CGPoint(x: (origin.x + 20), y: (origin.y)))
                    oval.addCurve(to: CGPoint(x: (origin.x + 20), y: (origin.y + 30)), controlPoint1: CGPoint(x: (origin.x + 30.5), y: (origin.y + 1.5)), controlPoint2: CGPoint(x: (origin.x + 30.5), y: (origin.y + 28.5)))
                    oval.addLine(to: CGPoint(x: (origin.x - 20), y: (origin.y + 30)))
                    oval.addCurve(to: CGPoint(x: (origin.x - 20), y: (origin.y)), controlPoint1: CGPoint(x: (origin.x - 30.5), y: (origin.y + 28.5)), controlPoint2: CGPoint(x: (origin.x - 30.5), y: (origin.y + 1.5)))
                    oval.close()
                }
                
                color.setStroke()
                color.setFill()
                oval.lineWidth = 3.0
                oval.stroke()
                oval.addClip()
                
                switch shading {
                case .striped:
                    addStriping()
                case .solid:
                    oval.fill()
                default:
                    break
                }
            default:
                break
            }
            
        }
        
        func drawSquiggle(in amounts: Int, of color: UIColor, with shading: Shading) {
            switch shape {
            case .squiggle:
                let squiggle = UIBezierPath()
                var numberOfElements: [CGPoint] {
                    get {
                        switch amounts {
                        case 1:
                            return [centerOrigin]
                        case 2:
                            return [upperMidOrigin, lowerMidOrigin]
                        case 3:
                            return [upperOrigin, centerOrigin, lowerOrigin]
                        default:
                            return []
                        }
                    }
                }
                for origin in numberOfElements {
                    squiggle.move(to: origin)
                    squiggle.addCurve(to: CGPoint(x: (origin.x + 30), y: origin.y), controlPoint1: CGPoint(x: (origin.x + 15), y: (origin.y + 12.5)), controlPoint2: CGPoint(x: (origin.x + 25), y: origin.y))
                    squiggle.addCurve(to: CGPoint(x: (origin.x + 7.5), y: (origin.y + 27.5)), controlPoint1: CGPoint(x: (origin.x + 37.5), y: CGFloat(origin.y + 5)), controlPoint2: CGPoint(x: (origin.x + 22.5), y: (origin.y + 30)))
                    squiggle.addCurve(to: CGPoint(x: CGFloat(origin.x - 30), y: (origin.y + 27.5)), controlPoint1: CGPoint(x: (origin.x - 15), y: (origin.y + 15)), controlPoint2: CGPoint(x: (origin.x - 15), y: (origin.y + 30)))
                    squiggle.addCurve(to: origin, controlPoint1: CGPoint(x: (origin.x - 32.5), y: (origin.y + 10)), controlPoint2: CGPoint(x: (origin.x - 10), y: (origin.y - 5)))
                    squiggle.close()
                }
                color.setStroke()
                color.setFill()
                squiggle.lineWidth = 3.0
                squiggle.stroke()
                squiggle.addClip()
                
                switch shading {
                case .striped:
                    addStriping()
                case .solid:
                    squiggle.fill()
                default:
                    break
                }
            default:
                break
            }
        }
        
        func drawDiamond(in amounts: Int, of color: UIColor, with shading: Shading) {
            switch shape {
            case .diamond:
                            let diamond = UIBezierPath()
                
                var numberOfElements: [CGPoint] {
                    get {
                        switch amounts {
                        case 1:
                            return [centerOrigin]
                        case 2:
                            return [upperMidOrigin, lowerMidOrigin]
                        case 3:
                            return [upperOrigin, centerOrigin, lowerOrigin]
                        default:
                            return []
                        }
                    }
                }
                
                for origin in numberOfElements {
                    diamond.move(to: origin)
                    diamond.addLine(to: CGPoint(x: (origin.x + 30), y: (origin.y + 15)))
                    diamond.addLine(to: CGPoint(x: origin.x, y: (origin.y + 30)))
                    diamond.addLine(to: CGPoint(x: (origin.x - 30), y: (origin.y + 15)))
                    diamond.close()
                }
                
                color.setStroke()
                color.setFill()
                diamond.lineWidth = 3.0
                diamond.stroke()
                diamond.addClip()
                
                switch shading {
                case .striped:
                    addStriping()
                case .solid:
                    diamond.fill()
                default:
                    break
                }
            default:
                break
            }
        }
        
        func addStriping() {
            let stripe = UIBezierPath()
            var newX = (centerOrigin.x / 2) - 60
            var currentY: CGFloat = 0
            stripe.move(to: CGPoint(x: newX, y: currentY))
            
            while newX < 200 {
                stripe.addLine(to: CGPoint(x: newX, y: currentY))
                newX += 4
                stripe.addLine(to: CGPoint(x: newX, y: currentY))
                if currentY == 0 {
                    currentY = 1000
                } else {
                    currentY = 0
                }
            }
            
            stripe.close()
            stripe.stroke()
        }
        
        
        guard let numberOfObjects = numberOfObjects else {
            return
        }
        guard let color = color else {
            return
        }
        guard let shading = shading else {
            return
        }
        guard let shape = shape else {
            return
        }
        
        switch shape {
        case .diamond:
            drawDiamond(in: numberOfObjects, of: color, with: shading)
        case .oval:
            drawOval(in: numberOfObjects, of: color, with: shading)
        case .squiggle:
            drawSquiggle(in: numberOfObjects, of: color, with: shading)
        }
        
    }
}

