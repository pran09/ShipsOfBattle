//
//  ViewController.swift
//  ShipsOfBattle
//
//  Created by 王澜睎 on 2019/5/2.
//  Copyright © 2019 trey. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{
    
    var randVal: Int!
    var hosting: Bool!
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startButton.isHidden = true
        hosting = false
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate=self
        mcSession.disconnect()
        randVal = Int.random(in: 0 ... 100)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gvc = segue.destination as? GameViewController {
            // send connection info upon segue to GameViewController
            gvc.hosting = hosting
            gvc.peerID = peerID
            gvc.mcSession = mcSession
            gvc.mcAdvertiserAssistant = mcAdvertiserAssistant
            gvc.randVal = randVal
        }
    }
    
    @IBAction func connectButtonTapped(_ sender: Any) {
        if mcSession.connectedPeers.count == 0 && !hosting{
            let connectActionSheet = UIAlertController(title: "Start a Game", message: "Do you want to Host or Join a game?", preferredStyle: .actionSheet)
            connectActionSheet.addAction(UIAlertAction(title: "Host a Game", style: .default, handler: {
                (action:UIAlertAction) in
                self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "doesnt-matter", discoveryInfo: nil, session: self.mcSession)
                self.mcAdvertiserAssistant.start()
                self.hosting = true
            }))
            
            connectActionSheet.addAction(UIAlertAction(title: "Join a Game", style: .default, handler: {
                (action:UIAlertAction) in
                let mcBrowser = MCBrowserViewController(serviceType: "doesnt-matter", session: self.mcSession)
                mcBrowser.delegate = self
                self.present(mcBrowser, animated:true, completion: nil)
            }))
            connectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(connectActionSheet, animated:true, completion: nil)
            
        }else if mcSession.connectedPeers.count == 0 && hosting{
            let waitActionSheet = UIAlertController(title: "Waiting...", message: "Waiting for opponent to join the game", preferredStyle: .actionSheet)
            waitActionSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: {
                (action) in
                self.mcSession.disconnect()
                self.hosting = false
            }))
            waitActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(waitActionSheet, animated:true, completion: nil)
            
        }else{
            let disconnectActionSheet = UIAlertController(title: "Are you sure you want to disconnect?", message: nil, preferredStyle: .actionSheet)
            disconnectActionSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: {
                (action:UIAlertAction) in
                self.mcSession.disconnect()
                self.startButton.isHidden = true
                self.textLabel.text = "Connect to another user"
            }))
            disconnectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(disconnectActionSheet, animated:true, completion: nil)
            
        }
    }
    
    func changeView(hide: Bool) {
        if hide {
            startButton.isHidden = true
            textLabel.text = "Connect to another user"
        } else {
            startButton.isHidden = false
            textLabel.text = "Connected! Press start begin"
        }
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.changeView(hide: false)
            }
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.changeView(hide: true)
                let ac = UIAlertController(title: "Lost Connection to Opponent", message: "The connection to your opponent was lost. Find another opponent", preferredStyle: .alert)
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
//            self.recMsg = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
//            self.chatTextView.text = self.chatTextView.text+self.recMsg
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
