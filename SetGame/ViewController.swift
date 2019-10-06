//
//  ViewController.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/13/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlet for the label.
    @IBOutlet private weak var consoleLabel: UILabel!
    
    
    //MARK: Outlet for the CardTableView.
    @IBOutlet weak var cardsContainerView: CardTableView!
    
    
    // MARK: Outlet for the "New game" button.
    @IBAction private func newGame(_ sender: UIButton) {
        game.startNewGame()
        
        while cardsContainerView.subviews.count > 12 {
            cardsContainerView.subviews.last?.removeFromSuperview()
        }
        updateViewFromModel()
    }
    
    //MARK: Outlet for the "3 more cards" button.
    @IBAction private func openThreeMoreCards(_ sender: UIButton) {
        if !game.currentDeck.isEmpty {
            //TODO: Write some code that deals 3 more cards each time the button is pressed.
        } else {
            consoleLabel.text = "There's no more cards in the deck."
        }
    }
    
    //MARK: Outlet for the "Find a set" button.
    @IBAction func findSet(_ sender: UIButton) {
        game.findSet()
        print(game.foundSetArray)
        updateViewFromModel()
        if game.foundSetArray.isEmpty {
            consoleLabel.text = "There is no set on the board."
        }
    }
    
    
    //MARK: Action for touching card event.
    @IBAction private func touchCard(_ sender: UIButton) {
        let temp = game.matchedCards.count
        if let index = cardsContainerView.subviews.firstIndex(of: sender) {
            game.chooseCard(at: index)
        }
        
        if cardsContainerView.subviews.count > 12 {
            if temp != game.matchedCards.count {
                while cardsContainerView.subviews.count > 12 {
                    cardsContainerView.subviews.last?.removeFromSuperview()
                }
            }
        }
        updateViewFromModel()
    }
    
    
    //MARK: Refference to the Model of this game.
    private lazy var game = SetGame(numberOfCards: 12)
    
    
    
    //MARK: This property is used by label to decide what to display.
    private(set) var numberOfSets = 0 {
        didSet {
            switch numberOfSets {
            case 0:
                consoleLabel.text = "Find a set by touching 3 cards."
            default:
                consoleLabel.text = "Number of sets found: \(numberOfSets)"
            }
        }
    }
    
    //MARK: Updates view from mode.
    private func updateViewFromModel() {
        
        if cardsContainerView.cardTable.count > game.cardTable.count {
            cardsContainerView.removeCards(byAmount: cardsContainerView.cardTable.count - game.cardTable.count)
        }
        
        for (index, cardButton) in cardsContainerView.cardTable.enumerated() {
            let currentCard = game.cardTable[index]
            
            // Color feature:
            switch currentCard.color {
            case "Green":
                cardButton.color = #colorLiteral(red: 0.07156927139, green: 0.8168805242, blue: 0.09210438281, alpha: 1)
            case "Purple":
                cardButton.color = .purple
            case "Red":
                cardButton.color = .red
            default:
                break
            }
            
            // Number feature:
            switch currentCard.numberOfObjects {
            case 1:
                cardButton.numberOfObjects = 1
            case 2:
                cardButton.numberOfObjects = 2
            case 3:
                cardButton.numberOfObjects = 3
            default:
                break
            }
            
            // Shading feature:
            switch currentCard.shading {
            case "Open":
                cardButton.shading = .open
            case "Solid":
                cardButton.shading = .solid
            case "Striped":
                cardButton.shading = .striped
            default:
                break
            }
            
            
            // Shape feature:
            switch currentCard.shape {
            case "Diamond":
                cardButton.shape = .diamond
            case "Squiggle":
                cardButton.shape = .squiggle
            case "Oval":
                cardButton.shape = .oval
            default:
                break
            }
            
            // Selection:
            if game.matchingArray.contains(currentCard) ||
                game.matchedCards.contains(currentCard) {
                cardButton.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            } else {
                cardButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.849352542)
            }
            
        }
        
        consoleLabel.text = "Number of sets found: \(numberOfSets)"
        
        handleDealMoreButton()
        
        
        
        
        numberOfSets = game.numberOfSets
        for index in game.cardTable.indices {
            let button = cardsContainerView.subviews[index]
            let card = game.cardTable[index]
            button.layer.cornerRadius = 8.0
            
            if game.foundSetArray.count > 3 {
                for number in game.foundSetArray {
                    cardsContainerView.subviews[number].layer.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.7518193493)
                }
            } else if game.foundSetArray.count < 3 {
                for index in cardsContainerView.subviews.indices {
                    cardsContainerView.subviews[index].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            
            if game.matchingArray.contains(game.cardTable[index]) {
                cardsContainerView.subviews[index].layer.borderWidth = 3.0
                cardsContainerView.subviews[index].layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            } else {
                cardsContainerView.subviews[index].layer.borderWidth = 0
                cardsContainerView.subviews[index].layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            }
            
            if game.matchingArray.count == 3 && game.qualify(array: game.matchingArray) == true {
                consoleLabel.text = "It's a set!"
                game.foundSetArray.removeAll()
            } else if game.matchingArray.count == 3 && game.qualify(array: game.matchingArray) == false {
                consoleLabel.text = "It's not a set."
            }
            
            for card in cardsContainerView.subviews {
                if game.matchingArray.isEmpty {
                    card.layer.borderWidth = 0
                }
            }
        }
    }
    
    
    func handleDealMoreButton() {
        //openThreeMoreCards.isEnabled = game.currentDeck.count > 3
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        cardsContainerView.addCards(byAmount: game.cardTable.count)
        updateViewFromModel()
    }
    
}

