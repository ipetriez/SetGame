//
//  SetGame.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/13/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import Foundation

struct SetGame {
    
    //MARK: All stored properties.
    private(set) var currentDeck = [Card]()
    var cardTable = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    var foundSetArray = [Int]()
    private(set) var numberOfSets = 0
    
    
    //MARK: This function is responsible for the checking whether the chosen cards make up a set or not.
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
    
    
    //MARK: This function is responsible for the behaviour of the model, when the user touches a card at any given moment of time.
    mutating func chooseCard(at index: Int) {
        assert(cardTable.indices.contains(index), "SetGame.chooseCard(at: \(index)): The card at chosen index is not on the card table now.")
        
        if !cardTable[index].isMatched {
            if selectedCards.count < 3 && !selectedCards.contains(cardTable[index]) {
                selectedCards.append(cardTable[index])
                print(index)
                print(cardTable[index])
            } else if selectedCards.count == 3 && !selectedCards.contains(cardTable[index]) {
                if qualify(array: selectedCards) == true {
                    print("It's set!")
                    numberOfSets += 1
                    for _ in 0..<selectedCards.count {
                        if !currentDeck.isEmpty {
                            if cardTable.count <= 12 {
                                matchedCards.append(cardTable.remove(at: cardTable.firstIndex(of: selectedCards.removeFirst())!))
                                cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
                            } else {
                                matchedCards.append(cardTable.remove(at: cardTable.firstIndex(of: selectedCards.removeFirst())!))
                            }
                        } else {
                            matchedCards.append(cardTable.remove(at: cardTable.firstIndex(of: selectedCards.removeFirst())!))
                        }
                    }
                } else {
                    print("It's not a set.")
                    selectedCards.removeAll()
                }
            } else {
                if let index = selectedCards.firstIndex(of: cardTable[index]) {
                    selectedCards.remove(at: index)
                }
            }
        }
    }
    
    
    //MARK: This function is responsible for the "Find a Set" button operation.
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
        while foundSetArray.count > 3 {
            foundSetArray.removeLast()
        }
    }
    
    
    //MARK: Method in charge of dealing the game's cards.
    /// - Parameter forAmount: The number of cards to be dealt.
    mutating func dealCards(forAmount amount: Int = 3) {
      guard amount > 0 else { return }
      guard currentDeck.count >= amount else {
        
        for card in matchedCards {
            let index = cardTable.firstIndex(of: card)!
          cardTable.remove(at: index)
        }
        
        return
      }
      
      var cardsToDeal = [Card]()
      
      for _ in 0..<amount {
        cardsToDeal.append(currentDeck.removeFirst())
      }
      
      for (index, card) in cardTable.enumerated() {
        if matchedCards.contains(card) {
          cardTable[index] = cardsToDeal.removeFirst()
        }
      }
      
      if !cardsToDeal.isEmpty {
        cardTable += cardsToDeal
      }
    }
    
    
    //MARK: Shuffles any array of cards.
    func shuffle(cards: inout [Card]) {
        var tempArray = cards
        var newArray = [Card]()
        for _ in 1...cards.count {
            newArray.append(tempArray.remove(at: tempArray.count.arc4random))
        }
        cards = newArray
    }
    
    
    //MARK: This function is responsible for the "New game" button operation.
    mutating func startNewGame() {
        for index in matchedCards.indices {
            currentDeck.append(matchedCards[index])
        }
        for index in cardTable.indices {
            currentDeck.append(cardTable[index])
        }
        cardTable.removeAll()
        matchedCards.removeAll()
        selectedCards.removeAll()
        foundSetArray.removeAll()
        
        for index in currentDeck.indices {
            currentDeck[index].isMatched = false
        }
        
        for _ in 1...12 {
            cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
        }
        numberOfSets = 0
    }
    
    
    //MARK: Initialization of all cards in the deck.
    init(numberOfCards: Int) {
        for _ in 1...81 {
            currentDeck.append(Card())
        }
        for _ in 0..<numberOfCards {
            cardTable.append(currentDeck.remove(at: currentDeck.count.arc4random))
        }
    }
}


//MARK: Extension for simplifying the randomization process.
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
