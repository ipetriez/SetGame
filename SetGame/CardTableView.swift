//
//  CardTable.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 9/26/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class CardTableView: SetGameMainSuperView {
    
    var cardTable = [CardView]()
    
    
    //MARK: The grid in charge of generating the calculated frame of each contained button.
    var grid = Grid(layout: Grid.Layout.aspectRatio(5.5/8))
    
    
    //MARK: The centered rect in which the buttons are going to be positioned.
    var centeredRect: CGRect {
        get {
            return CGRect(x: bounds.size.width * 0.025,
                          y: bounds.size.height * 0.025,
                          width: bounds.size.width * 0.95,
                          height: bounds.size.height * 0.95)
        }
    }
    
    
    //MARK: View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        
        for (i, card) in cardTable.enumerated() {
            if let frame = grid[i] {
                card.frame = frame
                card.layer.cornerRadius = 7
                card.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                card.layer.borderWidth = 0.5
            }
        }
    }
    
    //MARK: Adds new cards to the UI.
    /// - Parameter byAmount: The number of cards to be added.
    func addCards(byAmount numberOfCards: Int = 3) {
      let cards = (0..<numberOfCards).map { _ in CardView() }
      
      for card in cards {
        addSubview(card)
      }
      
      cardTable += cards
      
      grid.cellCount = cardTable.count
      
      setNeedsLayout()
    }
    
    //MARK: Removes n cards from the cardTable container.
    func removeCards(byAmount numberOfCards: Int) {
      guard cardTable.count >= numberOfCards else { return }
    
      for index in 0..<numberOfCards {
        let card = cardTable[index]
        card.removeFromSuperview()
      }
      
      cardTable.removeSubrange(0..<numberOfCards)
      grid.cellCount = cardTable.count
      
      setNeedsLayout()
    }
    
    //MARK: Removes all cards from the container.
    func clearCardContainer() {
      cardTable = []
      grid.cellCount = 0
      removeAllSubviews()
      setNeedsLayout()
    }
    
}


extension UIView {
    
    /// Removes all subviews.
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
