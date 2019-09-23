//
//  SetGame.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/13/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import Foundation

struct SetGame {
    
    var currentDeck = [Card]()
    var cardTable = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var matchingArray = [Card]()
    var foundSetArray = [Int]()
    private(set) var numberOfSets = 0
    
    mutating func qualify(array: [Card]) -> Bool {
        if array.count == 3 {
            if (array[0].color == array[1].color && array[1].color == array[2].color) || (array[0].color != array[1].color && array[1].color != array[2].color && array[0].color != array[2].color),
                
                (array[0].numberOfObjects == array[1].numberOfObjects && array[1].numberOfObjects == array[2].numberOfObjects) || (array[0].numberOfObjects != array[1].numberOfObjects && array[1].numberOfObjects != array[2].numberOfObjects && array[0].numberOfObjects != array[2].numberOfObjects),
                
                (array[0].shape == array[1].shape && array[1].shape == array[2].shape) || (array[0].shape != array[1].shape && array[1].shape != array[2].shape && array[0].shape != array[2].shape),
                
                (array[0].shading == array[1].shading && array[1].shading == array[2].shading) || (array[0].shading != array[1].shading && array[1].shading != array[2].shading && array[0].shading != array[2].shading) {
                return true
            }
        }
        return false
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardTable.indices.contains(index), "SetGame.chooseCard(at: \(index)): The card at chosen index is not on the card table now.")
        
        if !cardTable[index].isMatched {
            if matchingArray.count < 3 && !matchingArray.contains(cardTable[index]) {
                matchingArray.append(cardTable[index])
                print(index)
                print(cardTable[index])
            } else if matchingArray.count == 3 && !matchingArray.contains(cardTable[index]) {
                if qualify(array: matchingArray) == true {
                    print("It's set!")
                    numberOfSets += 1
                    for _ in 0..<matchingArray.count {
                        if !currentDeck.isEmpty {
                            if cardTable.count <= 12 {
                                matchedCards.append(cardTable.remove(at: cardTable.firstIndex(of: matchingArray.removeFirst())!))
                                cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
                            } else {
                                matchedCards.append(cardTable.remove(at: cardTable.firstIndex(of: matchingArray.removeFirst())!))
                            }
                        } else {
                            let index = cardTable.firstIndex(of: matchingArray.removeFirst())
                            cardTable[index!].isMatched = true
                        }
                    }
                } else {
                    print("It's not a set.")
                    matchingArray.removeAll()
                }
            } else {
                if let index = matchingArray.firstIndex(of: cardTable[index]) {
                    matchingArray.remove(at: index)
                }
            }
        }
    }
    
    mutating func findSet() {
        foundSetArray = []
        var tempArray = [Card]()
        for firstElement in cardTable {
            if qualify(array: tempArray) == true {
                for card in tempArray {
                    if cardTable.contains(card) {
                        foundSetArray.append(cardTable.firstIndex(of: card)!)
                    }
                }
                break
            } else if tempArray.count < 3, !tempArray.contains(firstElement) {
                tempArray.append(firstElement)
            } else if tempArray.count == 3, qualify(array: tempArray) == false, tempArray.contains(firstElement) {
                let index = tempArray.firstIndex(of: firstElement)
                tempArray.remove(at: index!)
            } else if tempArray.count == 3, qualify(array: tempArray) == false, !tempArray.contains(firstElement) {
                tempArray.removeFirst()
                tempArray.append(firstElement)
            }
            for secondElement in cardTable {
                if qualify(array: tempArray) == true {
                    for card in tempArray {
                        if cardTable.contains(card) {
                            foundSetArray.append(cardTable.firstIndex(of: card)!)
                        }
                    }
                    break
                } else if tempArray.count < 3, !tempArray.contains(secondElement) {
                    tempArray.append(secondElement)
                } else if tempArray.count == 3, qualify(array: tempArray) == false, tempArray.contains(secondElement) {
                    let index = tempArray.firstIndex(of: secondElement)
                    tempArray.remove(at: index!)
                } else if tempArray.count == 3, qualify(array: tempArray) == false, !tempArray.contains(secondElement) {
                    tempArray.remove(at: 1)
                    tempArray.append(secondElement)
                }
                for thirdElement in cardTable {
                    if qualify(array: tempArray) == true {
                        for card in tempArray {
                            if cardTable.contains(card) {
                                foundSetArray.append(cardTable.firstIndex(of: card)!)
                            }
                        }
                        break
                    } else if tempArray.count < 3, !tempArray.contains(thirdElement) {
                        tempArray.append(thirdElement)
                    } else if tempArray.count == 3, qualify(array: tempArray) == false, tempArray.contains(thirdElement) {
                        let index = tempArray.firstIndex(of: thirdElement)
                        tempArray.remove(at: index!)
                    } else if tempArray.count == 3, qualify(array: tempArray) == false, !tempArray.contains(thirdElement) {
                        tempArray.removeLast()
                        tempArray.append(thirdElement)
                    }
                }
            }
        }
    }
    
    
    
    mutating func startNewGame() {
        for index in matchedCards.indices {
            currentDeck.append(matchedCards[index])
        }
        for index in cardTable.indices {
            currentDeck.append(cardTable[index])
        }
        cardTable.removeAll()
        matchedCards.removeAll()
        matchingArray.removeAll()
        
        for index in currentDeck.indices {
            currentDeck[index].isMatched = false
        }
        
        for _ in 1...12 {
            cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
        }
        numberOfSets = 0
    }
    
    
    init(numberOfCards: Int) {
        for _ in 1...81 {
            currentDeck.append(Card())
        }
        for _ in 0..<numberOfCards {
            cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
        }
    }
}



extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
