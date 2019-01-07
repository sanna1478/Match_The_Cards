//
//  CardModel.swift
//  Match The Cards
//
//  Created by Shreyash Annapureddy on 1/3/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import Foundation

class CardModel {
    func getCard()->[Card]{
        var generatedCards = [Card]()
        
        // Store generated randNum
        var genRandNum = [Int]()
        
        while genRandNum.count<8{
            let randNum = arc4random_uniform(13) + 1
            
            if !genRandNum.contains(Int(randNum)){
            
                let cardOne = Card()
                let cardTwo = Card()
                cardOne.cardName = "card\(randNum)"
                cardTwo.cardName = "card\(randNum)"
            
                generatedCards.append(cardOne)
                generatedCards.append(cardTwo)
                genRandNum.append(Int(randNum))
            }
        }
        
        // Shuffle the cards
        for index in 0..<generatedCards.count {
            let randNum = Int(arc4random_uniform(UInt32(generatedCards.count)))
            let temp = generatedCards[index]
            
            generatedCards[index] = generatedCards[randNum]
            generatedCards[randNum] = temp
            
        }
        return generatedCards
    }
}
