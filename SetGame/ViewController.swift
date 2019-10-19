//
//  ViewController.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/13/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Refference to the Model.
    private lazy var game = SetGame(numberOfCards: 12)
    
    
    //MARK: View, containing all the cards.
    @IBOutlet private weak var cardsContainerView: CardTableView! {
        didSet {
            
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            cardsContainerView.addGestureRecognizer(rotationGesture)
            
            let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards))
            swipeDownGesture.direction = .down
            cardsContainerView.addGestureRecognizer(swipeDownGesture)
 
        }
    }
    
    
    //MARK: Makes cards on the table clickable.
    private func assignTargetActionToButtons() {
        for button in cardsContainerView.cardTable {
            button.addTarget(self, action: #selector(selectOrDeselectACard(_:)), for: .touchUpInside)
        }
    }
    
    
    //MARK: Responds to tapGesture.
    @objc func selectOrDeselectACard(_ sender: UIButton) {
        let index = cardsContainerView.cardTable.firstIndex(of: sender as! CardView)!
        game.chooseCard(at: index)
        
        if !game.foundSetArray.isEmpty {
            if let itemToBeDeleted = game.foundSetArray.firstIndex(of: index) {
                game.foundSetArray.remove(at: itemToBeDeleted)
            } else {
                game.foundSetArray.removeAll()
            }
        }
        updateViewFromModel()
        if game.selectedCards.count == 3 && game.qualify(array: game.selectedCards) == false {
            consoleLabel.text = "It's not a set."
        }
    }
    
    
    //MARK: Responds to swipeDownGesture.
    @objc func dealThreeMoreCards() {
        if cardsContainerView.subviews.count <= 21 {
            openThreeMoreCards(openThreeMoreCardsButton)
            updateViewFromModel()
        }
    }
    
    
    //MARK: Responds to rotationGesture.
    @objc func shuffleCards() {
        game.shuffle(cards: &game.cardTable)
        updateViewFromModel()
    }
    
    
    //MARK: Outlet for the label.
    @IBOutlet private weak var consoleLabel: UILabel!
    
    
    //MARK: This property is used by the label to decide what to display.
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
    
    
    // MARK: Outlet for the "New game" button.
    @IBAction private func newGame(_ sender: UIButton) {
        game.startNewGame()
        cardsContainerView.layoutSubviews()
        updateViewFromModel()
    }
    
    
    //MARK: Outlet for the "3 more cards" button.
    @IBOutlet weak var openThreeMoreCardsButton: UIButton!
    @IBAction private func openThreeMoreCards(_ sender: UIButton) {
        if !game.currentDeck.isEmpty {
            game.dealCards()
            cardsContainerView.addCards(byAmount: 3)
            assignTargetActionToButtons()
        } 
        updateViewFromModel()
    }
    
    
    //MARK: Outlet for the "Find a set" button.
    @IBAction private func findSet(_ sender: UIButton) {
        game.findSet()
        for _ in 1...5 {
            if game.foundSetArray.isEmpty {
                shuffleCards()
                game.findSet()
            }
        }
        print(game.foundSetArray)
        updateViewFromModel()
        if game.foundSetArray.isEmpty {
            consoleLabel.text = "There is no set on the board."
        }
    }
    
    
    //MARK: Updates view from model.
    private func updateViewFromModel() {
        
        // Updates label's text.
        numberOfSets = game.numberOfSets
        
        // Removes excessive subviews from cardsContainerView
        if cardsContainerView.cardTable.count > game.cardTable.count {
            cardsContainerView.removeCards(byAmount: cardsContainerView.cardTable.count - game.cardTable.count)
        }
        
        // Hides and unhides "3 more cards" button.
        if cardsContainerView.subviews.count > 21 || game.currentDeck.isEmpty {
            openThreeMoreCardsButton.isHidden = true
        } else {
            openThreeMoreCardsButton.isHidden = false
        }
        
        // Matching cards from model with the views in cardsContainerView
        for (index, cardView) in cardsContainerView.cardTable.enumerated() {
            let setCard = game.cardTable[index]
            
            switch setCard.color {
            case "Green":
                cardView.color = #colorLiteral(red: 0.07156927139, green: 0.8168805242, blue: 0.09210438281, alpha: 1)
            case "Purple":
                cardView.color = #colorLiteral(red: 0.3828546895, green: 0.132271503, blue: 0.6935838298, alpha: 1)
            case "Red":
                cardView.color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            default:
                break
            }
            
            switch setCard.numberOfObjects {
            case 1:
                cardView.numberOfObjects = 1
            case 2:
                cardView.numberOfObjects = 2
            case 3:
                cardView.numberOfObjects = 3
            default:
                break
            }
            
            switch setCard.shading {
            case "Open":
                cardView.shading = .open
            case "Solid":
                cardView.shading = .solid
            case "Striped":
                cardView.shading = .striped
            default:
                break
            }
            
            switch setCard.shape {
            case "Diamond":
                cardView.shape = .diamond
            case "Squiggle":
                cardView.shape = .squiggle
            case "Oval":
                cardView.shape = .oval
            default:
                break
            }
            
            // Shows selection, when cards are touched.
            if game.selectedCards.contains(game.cardTable[index]) {
                cardsContainerView.cardTable[index].layer.borderWidth = 3
                cardsContainerView.cardTable[index].layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            } else {
                cardsContainerView.cardTable[index].layer.borderWidth = 1.5
                cardsContainerView.cardTable[index].layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            }
            
            // Highlights sought cards when the "Find a Set" button is touched.
            if !game.foundSetArray.isEmpty {
                for number in game.foundSetArray {
                    cardsContainerView.cardTable[number].layer.borderWidth = 3
                    cardsContainerView.cardTable[number].layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        }
    }
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        cardsContainerView.addCards(byAmount: game.cardTable.count)
        assignTargetActionToButtons()
        updateViewFromModel()
    }
}

