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

class GameViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet var placingLabel: UILabel!
    var placeCount = 5
    var userState = Array(repeating: 0, count: 100)
    
    @IBAction func placing_ships_action(_ sender: Any) {
        if ((userState[(sender as AnyObject).tag - 1] == 0) && (placeCount > 0)) {
            userState[(sender as AnyObject).tag - 1] = 1
            (sender as! UIButton).backgroundColor = UIColor.blue
        }
        else if ((userState[(sender as AnyObject).tag - 1] == 1) && (placeCount > 0)) {
            userState[(sender as AnyObject).tag - 1] = 0
            (sender as! UIButton).backgroundColor = UIColor.white
        }
        // update background color

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
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    
    @IBAction func pressedPlayButton(sender: Any) {
        
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
        }
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
