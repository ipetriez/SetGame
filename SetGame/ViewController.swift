//
//  ViewController.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 8/13/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var consoleLabel: UILabel!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.startNewGame()
        for i in anotherThreeCards {
            i.setAttributedTitle(NSAttributedString(string: "", attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), .strokeColor:#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]), for: UIControl.State.normal)
        }
        while cardTable.count > 12 {
            cardTable.removeLast()
        }
        updateViewFromModel()
    }
    
    @IBAction private func openThreeMoreCards(_ sender: UIButton) {
        if !game.currentDeck.isEmpty {
            if cardTable.count <= 12 {
                for button in anotherThreeCards {
                    cardTable.append(button)
                    game.cardTable.append(game.currentDeck.remove(at: game.currentDeck.count.arc4random))
                    updateViewFromModel()
                }
            }
        } else {
            consoleLabel.text = "There's no more cards in the deck."
        }
    }
    
    @IBOutlet private var cardTable: [UIButton]!
    
    @IBOutlet private var anotherThreeCards: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        let temp = game.matchedCards.count
        if let index = cardTable.firstIndex(of: sender) {
            game.chooseCard(at: index)
        }
        
        if cardTable.count > 12 {
            if temp != game.matchedCards.count {
                for i in anotherThreeCards {
                    i.setAttributedTitle(NSAttributedString(string: "", attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), .strokeColor:#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]), for: UIControl.State.normal)
                    i.layer.borderWidth = 0
                }
                while cardTable.count > 12 {
                    cardTable.removeLast()
                }
            }
        }
        updateViewFromModel()
    }
    
    private lazy var game = SetGame(numberOfCards: cardTable.count)
    
    private func render(card: Card) -> String {
        var title = ""
        for _ in 0..<card.numberOfObjects {
            if card.isMatched == true {
                title.append("\n")
            } else if card.shape == "Triangle" {
                title.append("▲\n")
            } else if card.shape == "Round" {
                title.append("●\n")
            } else if card.shape == "Square" {
                title.append("■\n")
            }
        }
        title.removeLast()
        return title
    }
    
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
    
    private func updateViewFromModel() {
        numberOfSets = game.numberOfSets
        for index in cardTable.indices {
            let button = cardTable[index]
            let card = game.cardTable[index]
            button.layer.cornerRadius = 8.0
            
            if card.color == "Purple" && card.shading == "Solid" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), .strokeColor:#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Purple" && card.shading == "Striped" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 0.2478863442), .strokeColor:#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Purple" && card.shading == "Open" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:5.0, .strokeColor:#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Red" && card.shading == "Solid" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .strokeColor:#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Red" && card.shading == "Striped" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2543610873), .strokeColor:#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Red" && card.shading == "Open" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:5.0, .strokeColor:#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Green" && card.shading == "Solid" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), .strokeColor:#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Green" && card.shading == "Striped" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:-5.0, .foregroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.2461740154), .strokeColor:#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]), for: UIControl.State.normal)
            } else if card.color == "Green" && card.shading == "Open" {
                button.setAttributedTitle(NSAttributedString(string: render(card: card), attributes: [.strokeWidth:5.0, .strokeColor:#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]), for: UIControl.State.normal)
            }
            
            if game.matchingArray.contains(game.cardTable[index]) {
                cardTable[index].layer.borderWidth = 3.0
                cardTable[index].layer.borderColor = UIColor.blue.cgColor
            } else {
                cardTable[index].layer.borderWidth = 0
                cardTable[index].layer.borderColor = UIColor.blue.cgColor
            }
            
            for card in cardTable {
                if game.matchingArray.isEmpty {
                    card.layer.borderWidth = 0
                }
            }
            
            for index in anotherThreeCards.indices {
                let button = anotherThreeCards[index]
                button.layer.cornerRadius = 8.0
            }
        }
    }
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
}

