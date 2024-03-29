//
//  CardTable.swift
//  SetGame
//
//  Created by Sergey Petrosyan on 9/26/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class CardTableView: SetGameMainSuperView {
    
    private(set) var cardTable = [CardView]()
    
    
    //MARK: The grid in charge of generating the calculated frame of each contained button.
    private var grid = Grid(layout: Grid.Layout.aspectRatio(5/8))
    
    
    //MARK: The centered rect in which the buttons are going to be positioned.
    private var centeredRect: CGRect {
        get {
            return CGRect(x: bounds.size.width * 0.025,
                          y: bounds.size.height * 0.025,
                          width: bounds.size.width * 0.95,
                          height: bounds.size.height)
        }
    }
    
    
    //MARK: View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        
        for (i, card) in cardTable.enumerated() {
            if let frame = grid[i] {
                card.frame = frame
                card.layer.cornerRadius = 12
                card.layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                card.layer.borderWidth = 1.5
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
}
