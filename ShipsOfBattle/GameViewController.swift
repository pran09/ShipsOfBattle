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
    var placeCount = 5
    var myTurn = false
    var userState = Array(repeating: 0, count: 100)
    var oppState = Array(repeating: 0, count: 100)
    
    
    @IBAction func placing_ships_action(_ sender: Any) {
        if ((userState[(sender as AnyObject).tag - 1] == 0) && (placeCount > 0)) {
            userState[(sender as AnyObject).tag - 1] = 1
            // update background color
            (sender as! UIButton).backgroundColor = UIColor.blue
        }
        else if ((userState[(sender as AnyObject).tag - 1] == 1) && (placeCount > 0)) {
            userState[(sender as AnyObject).tag - 1] = 0
            (sender as! UIButton).backgroundColor = UIColor.white
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
        if (placeCount == 5) { //place carrier
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
                }
            }
        }
        else if (placeCount == 4) { //place battleship
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
                }
            }
        }
        else if ((placeCount == 3) || (placeCount == 2)) { //place cruiser or submarine
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
                        if (placeCount == 3) {
                            placingLabel.text = "Select 3 spaces for your submarine"
                        } else {
                            placingLabel.text = "Select 2 spaces for your destroyer"
                        }
                        placeCount -= 1
                    }
                }
                else if ((userState[first!+10] == 1) && (userState[first!+20] == 1)){
                    
                    for i in 0...2 {
                        let tmpButton = self.view.viewWithTag(first!+(10*i)+1) as! UIButton
                        tmpButton.backgroundColor = UIColor.black
                        userState[first!+(10*i)] = 2
                    }
                    if (placeCount == 3) {
                        placingLabel.text = "Select 3 spaces for your submarine"
                    } else {
                        placingLabel.text = "Select 2 spaces for your destroyer"
                    }
                    placeCount -= 1
                }
            }
        }
        else if (placeCount == 1) { //place cruiser or submarine
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
                }
            }
        }
        else if (placeCount == 0) {
            //Do something after all ships have been placed
            turnLabel.isHidden = false
            switchButton.isHidden = false
            
            placingLabel.text = "Turn: "
            titleLabel.text = "Battle!"
            
            //send grid data to opponent
            if hosting == false{
//                try mcSession.send(Data, toPeers: mcSession.connectedPeers, with: .reliable)
            }
        }
    }
    @IBAction func switch_view_action(_ sender: Any) {
        if (turnLabel.text == "Your Ships") {
            turnLabel.text = "Your Attacks"
            //update grid to show player's attacks
        }
        else if (turnLabel.text == "Your Attacks") {
            turnLabel.text = "Your Ships"
            //update grid to show player's ships
        }
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
                // TODO: do something if we get disconnected from the opponent
            }
        @unknown default:
            print("Unknown case")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        self.recMsg = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
//        self.chatTextView.text = self.chatTextView.text+self.recMsg
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
