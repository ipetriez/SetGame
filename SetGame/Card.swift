//
//  Card.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/23/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isMatched = false
    
    private var identifier: Int
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    private(set) var numberOfObjects: Int
    private static var definedNumberOfObjects = 0
    private static func defineNumberOfObjects() -> Int {
        if identifierFactory > 0 && identifierFactory <= 27 {
            definedNumberOfObjects = 1
        } else if identifierFactory > 27 && identifierFactory <= 54 {
            definedNumberOfObjects = 2
        } else if identifierFactory > 54 && identifierFactory <= 81 {
            definedNumberOfObjects = 3
        }
        return definedNumberOfObjects
    }
    
    private(set) var shape: String
    private static var definedShape = ""
    private static func defineShape() -> String {
        if (identifierFactory > 0 && identifierFactory <= 9) || (identifierFactory > 27 && identifierFactory <= 36) || (identifierFactory > 54 && identifierFactory <= 63) {
            definedShape = "Oval"
        } else if (identifierFactory > 9 && identifierFactory <= 18) || (identifierFactory > 36 && identifierFactory <= 45) || (identifierFactory > 63 && identifierFactory <= 72) {
            definedShape = "Diamond"
        } else {
            definedShape = "Squiggle"
        }
        return definedShape
    }
    
    
    private(set) var shading: String
    private static var definedShading = ""
    private static func defineShading() -> String {
        if identifierFactory % 3 == 1 {
            definedShading = "Solid"
        } else if identifierFactory % 3 == 2 {
            definedShading = "Striped"
        } else if identifierFactory % 3 == 0 {
            definedShading = "Open"
        }
        return definedShading
    }
    
    
    private(set) var color: String
    private static var definedColor = ""
    private static func defineColor() -> String {
        for i in stride(from: 1, to: 81, by: 9) {
            if identifierFactory == i || identifierFactory == (i + 1) || identifierFactory == (i + 2) {
                definedColor = "Green"
            } else if identifierFactory == (i + 3) || identifierFactory == (i + 4) || identifierFactory == (i + 5) {
                definedColor = "Red"
            } else if identifierFactory == (i + 6) || identifierFactory == (i + 7) || identifierFactory == (i + 8) {
                definedColor = "Purple"
            }
        }
        return definedColor
    }
    
    
    init() {
        identifier = Card.getUniqueIdentifier()
        numberOfObjects = Card.defineNumberOfObjects()
        shape = Card.defineShape()
        color = Card.defineColor()
        shading = Card.defineShading()
    }
}
