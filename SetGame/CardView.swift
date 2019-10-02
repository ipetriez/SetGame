//
//  CardView.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 9/26/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class CardView: CardTableView {
    
    override func draw(_ rect: CGRect) {
        let cardsBackground = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.white.setFill()
        cardsBackground.fill()
        
        let upperOrigin = CGPoint(x: 100, y: 40)
        let upperMidOrigin = CGPoint(x: 100, y: 80)
        let centerOrigin = CGPoint(x: 100, y: 120)
        let lowerMidOrigin = CGPoint(x: 100, y: 160)
        let lowerOrigin = CGPoint(x: 100, y: 200)
        
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
        
        func drawOval(in amounts: Int, of color: UIColor, with shading: Shading) {
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
                oval.addLine(to: CGPoint(x: (origin.x + 40), y: (origin.y)))
                oval.addCurve(to: CGPoint(x: (origin.x + 40), y: (origin.y + 60)), controlPoint1: CGPoint(x: (origin.x + 61), y: (origin.y + 3)), controlPoint2: CGPoint(x: (origin.x + 61), y: (origin.y + 57)))
                oval.addLine(to: CGPoint(x: (origin.x - 40), y: (origin.y + 60)))
                oval.addCurve(to: CGPoint(x: (origin.x - 40), y: (origin.y)), controlPoint1: CGPoint(x: (origin.x - 61), y: (origin.y + 57)), controlPoint2: CGPoint(x: (origin.x - 61), y: (origin.y + 3)))
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
        }
        
        
        func drawSquiggle(in amounts: Int, of color: UIColor, with shading: Shading) {
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
                squiggle.addCurve(to: CGPoint(x: (origin.x + 60), y: origin.y), controlPoint1: CGPoint(x: (origin.x + 30), y: (origin.y + 25)), controlPoint2: CGPoint(x: (origin.x + 50), y: origin.y))
                squiggle.addCurve(to: CGPoint(x: (origin.x + 15), y: (origin.y + 55)), controlPoint1: CGPoint(x: (origin.x + 75), y: CGFloat(origin.y + 10)), controlPoint2: CGPoint(x: (origin.x + 45), y: (origin.y + 60)))
                squiggle.addCurve(to: CGPoint(x: CGFloat(origin.x - 60), y: (origin.y + 55)), controlPoint1: CGPoint(x: (origin.x - 30), y: (origin.y + 30)), controlPoint2: CGPoint(x: (origin.x - 30), y: (origin.y + 60)))
                squiggle.addCurve(to: origin, controlPoint1: CGPoint(x: (origin.x - 65), y: (origin.y + 20)), controlPoint2: CGPoint(x: (origin.x - 20), y: (origin.y - 10)))
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
        }
        
        
        func drawDiamond(in amounts: Int, of color: UIColor, with shading: Shading) {
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
                diamond.addLine(to: CGPoint(x: (origin.x + 60), y: (origin.y + 30)))
                diamond.addLine(to: CGPoint(x: origin.x, y: (origin.y + 60)))
                diamond.addLine(to: CGPoint(x: (origin.x - 60), y: (origin.y + 30)))
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
        
        
    }

}
