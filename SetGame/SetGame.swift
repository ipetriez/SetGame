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
    private(set) var numberOfSets = 0
    
    mutating private func qualify(array: [Card]) {
        if matchingArray.count == 3 {
            if (matchingArray[0].color == matchingArray[1].color && matchingArray[1].color == matchingArray[2].color) || (matchingArray[0].color != matchingArray[1].color && matchingArray[1].color != matchingArray[2].color && matchingArray[0].color != matchingArray[2].color) {
                if (matchingArray[0].numberOfObjects == matchingArray[1].numberOfObjects && matchingArray[1].numberOfObjects == matchingArray[2].numberOfObjects) || (matchingArray[0].numberOfObjects != matchingArray[1].numberOfObjects && matchingArray[1].numberOfObjects != matchingArray[2].numberOfObjects && matchingArray[0].numberOfObjects != matchingArray[2].numberOfObjects) {
                    if (matchingArray[0].shape == matchingArray[1].shape && matchingArray[1].shape == matchingArray[2].shape) || (matchingArray[0].shape != matchingArray[1].shape && matchingArray[1].shape != matchingArray[2].shape && matchingArray[0].shape != matchingArray[2].shape) {
                        if (matchingArray[0].shading == matchingArray[1].shading && matchingArray[1].shading == matchingArray[2].shading) || (matchingArray[0].shading != matchingArray[1].shading && matchingArray[1].shading != matchingArray[2].shading && matchingArray[0].shading != matchingArray[2].shading) {
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
                        print("It's not a set.")
                        matchingArray.removeAll()
                    }
                } else {
                    print("It's not a set.")
                    matchingArray.removeAll()
                }
            } else {
                print("It's not a set.")
                matchingArray.removeAll()
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardTable.indices.contains(index), "SetGame.chooseCard(at: \(index)): The card at chosen index is not on the card table now.")
        
        if !cardTable[index].isMatched {
            if matchingArray.count < 3 && !matchingArray.contains(cardTable[index]) {
                matchingArray.append(cardTable[index])
                print(index)
                print(cardTable[index])
            } else {
                if let index = matchingArray.firstIndex(of: cardTable[index]) {
                    matchingArray.remove(at: index)
                }
            }
            qualify(array: matchingArray)
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
