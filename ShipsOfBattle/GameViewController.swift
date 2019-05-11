//
//  GameViewController.swift
//  ShipsOfBattle
//
//  Created by Davis Robeson on 4/24/19.
//  Copyright © 2019 trey. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{
    
    var randVal: Int!
    var hosting:Bool!
    var peerID:MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var placingLabel: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var switchButton: UIButton!
    @IBOutlet var actionButton: UIButton!
    var placeCount = 7
    var selectedAttacks = 0
    var myTurn = false
    var myView = true
    var start = false
    var oppReady = false
    var hits = 0
    var misses = 0
    var hitRate = 0.0
    var userState = Array(repeating: 0, count: 100)
    var oppState = Array(repeating: 0, count: 100)
    var userAttacks = Array(repeating: 0, count: 100)
    var attacks = Array(repeating: 0, count: 5)
    var oppAttacks = Array(repeating: 0, count: 5)
    var prevAttacks = Array(repeating: 0, count: 5)
    var prevOppAttacks = Array(repeating: 0, count: 5)
    
    @IBAction func placing_ships_action(_ sender: Any) {
        if ((userState[(sender as AnyObject).tag - 1] == 0) && (placeCount > 1)) {
            userState[(sender as AnyObject).tag - 1] = 1
            // update background color
            (sender as! UIButton).backgroundColor = UIColor.blue
        }
        else if ((userState[(sender as AnyObject).tag - 1] == 1) && (placeCount > 1)) {
            userState[(sender as AnyObject).tag - 1] = 0
            (sender as! UIButton).backgroundColor = UIColor.white
        } else {
            if myTurn && myView == false && oppReady{
                // display blue x on selected button and update userAttacks array w/ value of 1
                if userAttacks[(sender as AnyObject).tag - 1] == 0 {
                    userAttacks[(sender as AnyObject).tag - 1] = 1
                    (sender as! UIButton).setTitle("x", for: .normal)
                    (sender as! UIButton).setTitleColor(UIColor.blue, for: .normal)
                    selectedAttacks += 1
                    placingLabel.text = "Turn: Yours (\(selectedAttacks)/5)"
                } else if userAttacks[(sender as AnyObject).tag - 1] == 1 {
                    userAttacks[(sender as AnyObject).tag - 1] = 0
                    (sender as! UIButton).setTitle("", for: .normal)
                    selectedAttacks -= 1
                    placingLabel.text = "Turn: Yours (\(selectedAttacks)/5)"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
        self.turnLabel.isHidden = true
        self.switchButton.isHidden = true
        mcSession.delegate = self
        print("Connected peers: \(mcSession.connectedPeers)")
        print("PeerID: \(String(describing: peerID))")
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func placeButton(sender: Any) {
        var selectedSpaces = 0
        for space in userState{
            if (space == 1) {
                selectedSpaces += 1
            }
        }
        if (placeCount == 7) { //place carrier
            if (selectedSpaces == 5) { //right amount of places selected
                let first = userState.firstIndex(of: 1)
                if ((userState[first!+1] == 1) && (userState[first!+2] == 1) && (userState[first!+3] == 1) && (userState[first!+4] == 1)){
                    let one = first!/10
                    let two = (first!+4)/10
                    if (one == two) {
                        //fix space background colors
                        for i in 0...4 {
                            let tmpButton = self.view.viewWithTag(first!+i+1) as! UIButton
                            tmpButton.backgroundColor = UIColor.black
                            userState[first!+i] = 2
                        }
                        placingLabel.text = "Select 4 spaces for your battleship"
                        placeCount -= 1
                    } else {
                        let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships cannot span multiple rows when placed horizontally", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        present(ac, animated: true)
                    }
                }
                else if ((userState[first!+10] == 1) && (userState[first!+20] == 1) && (userState[first!+30] == 1) && (userState[first!+40] == 1)){

                    for i in 0...4 {
                        let tmpButton = self.view.viewWithTag(first!+(10*i)+1) as! UIButton
                        tmpButton.backgroundColor = UIColor.black
                        userState[first!+(10*i)] = 2
                    }
                    placingLabel.text = "Select 4 spaces for your battleship"
                    placeCount -= 1
                } else {
                    let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships must be placed consecutively either horizontally or vertically", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Select 5 spaces in a horizontal or vertical line for your carrier", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        else if (placeCount == 6) { //place battleship
            if (selectedSpaces == 4) { //right amount of places selected
                let first = userState.firstIndex(of: 1)
                if ((userState[first!+1] == 1) && (userState[first!+2] == 1) && (userState[first!+3] == 1)){
                    let one = first!/10
                    let two = (first!+3)/10
                    if (one == two) {
                        //fix space background colors
                        for i in 0...3 {
                            let tmpButton = self.view.viewWithTag(first!+i+1) as! UIButton
                            tmpButton.backgroundColor = UIColor.black
                            userState[first!+i] = 2
                        }
                        placingLabel.text = "Select 3 spaces for your cruiser"
                        placeCount -= 1
                    } else {
                        let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships cannot span multiple rows when placed horizontally", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        present(ac, animated: true)
                    }
                }
                else if ((userState[first!+10] == 1) && (userState[first!+20] == 1) && (userState[first!+30] == 1)){
                    
                    for i in 0...3 {
                        let tmpButton = self.view.viewWithTag(first!+(10*i)+1) as! UIButton
                        tmpButton.backgroundColor = UIColor.black
                        userState[first!+(10*i)] = 2
                    }
                    placingLabel.text = "Select 3 spaces for your cruiser"
                    placeCount -= 1
                } else {
                    let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships must be placed consecutively either horizontally or vertically", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Select 4 spaces in a horizontal or vertical line for your battleship", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        else if ((placeCount == 5) || (placeCount == 4)) { //place cruiser or submarine
            if (selectedSpaces == 3) { //right amount of places selected
                let first = userState.firstIndex(of: 1)
                if ((userState[first!+1] == 1) && (userState[first!+2] == 1)){
                    let one = first!/10
                    let two = (first!+2)/10
                    if (one == two) {
                        //fix space background colors
                        for i in 0...2 {
                            let tmpButton = self.view.viewWithTag(first!+i+1) as! UIButton
                            tmpButton.backgroundColor = UIColor.black
                            userState[first!+i] = 2
                        }
                        if (placeCount == 5) {
                            placingLabel.text = "Select 3 spaces for your submarine"
                        } else {
                            placingLabel.text = "Select 2 spaces for your destroyer"
                        }
                        placeCount -= 1
                    } else {
                        let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships cannot span multiple rows when placed horizontally", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        present(ac, animated: true)
                    }
                }
                else if ((userState[first!+10] == 1) && (userState[first!+20] == 1)){
                    
                    for i in 0...2 {
                        let tmpButton = self.view.viewWithTag(first!+(10*i)+1) as! UIButton
                        tmpButton.backgroundColor = UIColor.black
                        userState[first!+(10*i)] = 2
                    }
                    if (placeCount == 5) {
                        placingLabel.text = "Select 3 spaces for your submarine"
                    } else {
                        placingLabel.text = "Select 2 spaces for your destroyer"
                    }
                    placeCount -= 1
                } else {
                    let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships must be placed consecutively either horizontally or vertically", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            } else {
                var msg = ""
                if placeCount == 5 {
                    msg = "Select 3 spaces in a horizontal or vertical line for your cruiser"
                } else {
                    msg = "Select 3 spaces in a horizontal or vertical line for your submarine"
                }
                let ac = UIAlertController(title: "Incorrect Ship Placement", message: msg, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        else if (placeCount == 3) { //place destroyer
            if (selectedSpaces == 2) { //right amount of places selected
                let first = userState.firstIndex(of: 1)
                if (userState[first!+1] == 1){
                    let one = first!/10
                    let two = (first!+1)/10
                    if (one == two) {
                        //fix space background colors
                        for i in 0...1 {
                            let tmpButton = self.view.viewWithTag(first!+i+1) as! UIButton
                            tmpButton.backgroundColor = UIColor.black
                            userState[first!+i] = 2
                        }
                        placingLabel.text = "All ships placed. Press OK"
                        placeCount -= 1
                    } else {
                        let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships cannot span multiple rows when placed horizontally", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        present(ac, animated: true)
                    }
                }
                else if (userState[first!+10] == 1){
                    for i in 0...1 {
                        let tmpButton = self.view.viewWithTag(first!+(10*i)+1) as! UIButton
                        tmpButton.backgroundColor = UIColor.black
                        userState[first!+(10*i)] = 2
                    }
                    placingLabel.text = "All ships placed. Press OK"
                    placeCount -= 1
                } else {
                    let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Ships must be placed consecutively either horizontally or vertically", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "Incorrect Ship Placement", message: "Select 2 spaces in a horizontal or vertical line for your destroyer", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        else if (placeCount == 2) {
            //Do something after all ships have been placed
            turnLabel.isHidden = false
            switchButton.isHidden = false
            placingLabel.text = "Waiting for opponent..."
            titleLabel.text = "Battle!"
            
            // DONE: run some method in case data is received before player has placed ships
            if start == false && oppReady{
                swapTurn(whosTurn: myTurn)
                if myTurn {
                    let dict: [String: String] = ["turn": "me"]
                    if self.sendData(dictionaryWithData: dict) == false{
                        print("turn info failed to send")
                    }
                } else {
                    let dict: [String: String] = ["turn": "you"]
                    if sendData(dictionaryWithData: dict) == false{
                        print("turn info failed to send")
                    }
                }
            }
            
            //send grid data to opponent
            if hosting == false{
                let dict: [String: Int] = ["randVal": randVal]
                if sendData(dictionaryWithData: dict) == false{
                    print("RandVal failed to send")
                }
            }
            
            start = true
            placeCount -= 1
        } else if (placeCount == 0) {
            // DONE: player whose turn it is, make 5 attacks then send result to opponent
            if myTurn {
                // pick 5 spots to attack
                var selectedSpaces = 0
                var i = 0
                for j in 0..<userAttacks.count {
                    if (userAttacks[j] == 1) {
                        selectedSpaces += 1
                        if i < 5 {
                            attacks[i] = j
                            i += 1
                        }
                    }
                }
                if selectedSpaces == 5 {
                    if prevAttacks != [0, 0, 0, 0, 0] {
                        for space in prevAttacks {
                            if userAttacks[space] == 4 {
                                userAttacks[space] = 2
                            } else if userAttacks[space] == 5 {
                                userAttacks[space] = 3
                            }
                        }
                    }
                    // check for hit/miss
                    for i in 0..<attacks.count {
                        if oppState[attacks[i]] == 2 {
                            // hit
//                            userAttacks[attacks[i]] = 2
                            userAttacks[attacks[i]] = 4
                            hits += 1
                        } else if oppState[attacks[i]] == 0 {
                            // miss
//                            userAttacks[attacks[i]] = 3
                            userAttacks[attacks[i]] = 5
                            misses += 1
                        }
                    }
                    myView = true
                    switch_view_action((Any).self)
                    let dict: [String: [Int]] = ["attacks": attacks]
                    if sendData(dictionaryWithData: dict) == false{
                        print("attacks failed to send")
                    }
                    prevAttacks = attacks
                    attacks = [0, 0, 0, 0, 0]
                    selectedAttacks = 0
                    swapTurn(whosTurn: false)
                } else {
                    let ac = UIAlertController(title: "Incorrect Number of Attacks", message: "Select exactly 5 spaces to attack", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        } else if (placeCount == -1) {
            // TODO: Gather and send stats to be sent to stats viewController
            // TODO: link to stats viewController
        }
    }
    @IBAction func switch_view_action(_ sender: Any) {
        if oppReady {
            if myView {
                myView = false
                turnLabel.text = "Your Attacks"
                //update grid to show player's attacks/opponent's ships
                for i in 0..<userAttacks.count {
                    let tmpButton = self.view.viewWithTag(i+1) as! UIButton
                    tmpButton.backgroundColor = UIColor.white
                    if userAttacks[i] == 1 {
                        // state: selected
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.blue, for: .normal)
                    } else if userAttacks[i] == 2 {
                        // state: hit
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.red, for: .normal)
                    } else if userAttacks[i] == 3 {
                        // state: miss
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.darkGray, for: .normal)
                    } else if userAttacks[i] == 0 {
                        tmpButton.setTitle("", for: .normal)
                    } else if userAttacks[i] == 4 {
                        tmpButton.backgroundColor = UIColor.lightGray
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.red, for: .normal)
                    } else if userAttacks[i] == 5 {
                        tmpButton.backgroundColor = UIColor.lightGray
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.darkGray, for: .normal)
                    }
                }
            } else {
                myView = true
                turnLabel.text = "Your Ships"
                //update grid to show player's ships/opponent's attacks
                for i in 0..<userState.count {
                    let tmpButton = self.view.viewWithTag(i+1) as! UIButton
                    if userState[i] == 0 {
                        tmpButton.backgroundColor = UIColor.white
                        tmpButton.setTitle("", for: .normal)
                    } else if userState[i] == 2 {
                        tmpButton.backgroundColor = UIColor.black
                        tmpButton.setTitle("", for: .normal)
                    } else if userState[i] == 3 {
                        tmpButton.backgroundColor = UIColor.black
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.red, for: .normal)
                    } else if userState[i] == 4 {
                        tmpButton.backgroundColor = UIColor.white
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.darkGray, for: .normal)
                    } else if userState[i] == 5 {
                        tmpButton.backgroundColor = UIColor.lightGray
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.red, for: .normal)
                    } else if userState[i] == 6 {
                        tmpButton.backgroundColor = UIColor.lightGray
                        tmpButton.setTitle("x", for: .normal)
                        tmpButton.setTitleColor(UIColor.darkGray, for: .normal)
                    }
                }
            }
        }
    }
    
    func swapTurn(whosTurn: Bool) {
        if whosTurn {
            placingLabel.text = "Turn: Yours (\(selectedAttacks)/5)"
            myTurn = true
            actionButton.isHidden = false
        } else {
            placingLabel.text = "Turn: Opponent's"
            myTurn = false
            actionButton.isHidden = true
        }
    }
    
    func checkForWin() {
        let check = userState.firstIndex(of: 2)
        if check == nil { // win
            // DONE: handle victory
            titleLabel.text = "Game Over"
            placingLabel.text = "Winner: Opponent"
//            oppReady = false
            myTurn = false
            myView = false
            switch_view_action((Any).self)
            let dict: [String: String] = ["winner": "you"]
            if sendData(dictionaryWithData: dict) == false{
                print("winner failed to send")
            }
            let ac = UIAlertController(title: "Winner: Opponent", message: "Your opponent has won the game, better luck next time!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            placeCount -= 1
            actionButton.setTitle("Finish", for: .normal)
            print("hits: \(hits)")
            print("misses: \(misses)")
            print("hitrate: \(100*hits/(hits + misses))")
        }
    }
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, Any>) -> Bool {
        var dataToSend: Data!

        do {
            try dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
        } catch let error as NSError{
            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return false
        }
        
        do {
            try mcSession.send(dataToSend, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                return false
                }

        return true
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                // TODO: If disconnected from opponent, alert user and return to start page
                let ac = UIAlertController(title: "Lost Connection to Opponent", message: "The connection to your opponent was lost. Returning to the starting page", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        @unknown default:
            print("Unknown case")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("Received from: \(peerID.displayName)")
        DispatchQueue.main.async {
            
            do {
                let dataDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Dictionary<String,AnyObject>

                if ((dataDictionary?["randVal"]) != nil){
                    if self.randVal < dataDictionary?["randVal"] as! Int { //opponent turn
                        //let opponent know it is their turn
                        if self.start {
                            self.swapTurn(whosTurn: false)
                            let dict: [String: String] = ["turn": "you"]
                            if self.sendData(dictionaryWithData: dict) == false{
                                print("turn info failed to send")
                            }
                        } else {
                            self.oppReady = true
                        }
                    } else { //my turn
                        if self.start {
                            self.swapTurn(whosTurn: true)
                            let dict: [String: String] = ["turn": "me"]
                            if self.sendData(dictionaryWithData: dict) == false{
                                print("turn info failed to send")
                            }
                        } else {
                            self.myTurn = true
                            self.oppReady = true
                        }
                    }
                } else if (dataDictionary?["turn"] != nil) {
                    if dataDictionary?["turn"] as! String == "you" {
                        // my turn
                        self.swapTurn(whosTurn: true)
                    } else if dataDictionary?["turn"] as! String == "me" {
                        // opponents's turn
                        self.swapTurn(whosTurn: false)
                    }
                    // send my array of ships to the host
                    let dict: [String: [Int]] = ["initArr": self.userState]
                    if self.sendData(dictionaryWithData: dict) == false{
                        print("turn info failed to send")
                    }
                } else if (dataDictionary?["initArr"] != nil) {
                    self.oppState = dataDictionary?["initArr"] as! [Int]
                    // send host's array to opponent
                    if self.hosting {
                        let dict: [String: [Int]] = ["initArr": self.userState]
                        if self.sendData(dictionaryWithData: dict) == false{
                            print("turn info failed to send")
                        }
                    }
                    self.placeCount -= 1
                    self.oppReady = true
                } else if (dataDictionary?["attacks"] != nil) {
                    self.oppAttacks = dataDictionary?["attacks"] as! [Int]
                    if self.prevOppAttacks != [0, 0, 0, 0, 0] {
                        for space in self.prevOppAttacks {
                            if self.userState[space] == 5 {
                                self.userState[space] = 3
                            } else if self.userState[space] == 6 {
                                self.userState[space] = 4
                            }
                        }
                    }
                    for space in self.oppAttacks {
                        if self.userState[space] == 2 {
                            // hit
//                            self.userState[space] = 3
                            self.userState[space] = 5
                        } else if self.userState[space] == 0 {
                            // miss
//                            self.userState[space] = 4
                            self.userState[space] = 6
                        }
                    }
                    self.myView = false
                    self.switch_view_action((Any).self)
                    self.swapTurn(whosTurn: true)
                    self.prevOppAttacks = self.oppAttacks
                    self.oppAttacks = [0, 0, 0, 0, 0]
                    self.checkForWin()
                } else if (dataDictionary?["winner"] != nil) {
                    if dataDictionary?["winner"] as! String == "you" {
                        self.titleLabel.text = "Game Over"
                        self.placingLabel.text = "Winner: You!"
//                        self.oppReady = false
                        self.myTurn = false
                        self.myView = true
                        self.switch_view_action((Any).self)
                        self.actionButton.isHidden = false
                        let ac = UIAlertController(title: "Winner: You!", message: "You won the game, nice job!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        self.placeCount -= 1
                        self.actionButton.setTitle("Finish", for: .normal)
                        print("hits: \(self.hits)")
                        print("misses: \(self.misses)")
                        print("hitrate: \(100*self.hits/(self.hits + self.misses))")
                    }
                }
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
