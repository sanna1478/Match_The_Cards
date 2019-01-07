//
//  ViewController.swift
//  Match The Cards
//
//  Created by Shreyash Annapureddy on 1/3/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    let model = CardModel()
    var cards = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliSeconds:Float = 20000 // 10 seconds in milliseconds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cards = model.getCard()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    @objc func timerElapsed() {
        milliSeconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliSeconds/1000)
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // Stop timer ince reaching zero
        if milliSeconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    // MARK: -UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of items/cells to be displayed into the collection view
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cards[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Stop user from selecting any cards when time is up
        if milliSeconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cards[indexPath.row]
        
         if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            SoundManager.playSound(.flip)
            card.isFlipped = true
            // Determine if it is the first or second card that has been flipped
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                // Second card has been flipped
                
                // TODO: Check if the two cards match
                checkForMatched(indexPath)
            }
        }
    }
    
    // MARK: -Game Logic
    func checkForMatched(_ secondFlippedCardIndex:IndexPath) {
        // Get the cells for the 2 revealed cards
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cards[firstFlippedCardIndex!.row]
        let cardTwo = cards[secondFlippedCardIndex.row]
        
        if cardOne.cardName == cardTwo.cardName {
            // It's a match
            SoundManager.playSound(.match)
            // Set the matched status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove both the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if the game has ended
        } else {
            // It's not a match
            SoundManager.playSound(.nomatch)
            
            // Set the flipped status of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Reload the collection view
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        // Determine if there are any cards unmatched
        var won = true
        
        for card in cards {
            if card.isMatched == false {
                won = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        if won {
            if milliSeconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
        } else {
            if milliSeconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}

