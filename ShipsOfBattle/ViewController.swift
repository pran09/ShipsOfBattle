//
//  ViewController.swift
//  ShipsOfBattle
//
//  Created by Davis Robeson on 4/26/19.
//  Copyright © 2019 trey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func showRulesSubView(sender: AnyObject) {
        let squareBackground = UIView(frame: CGRect(x:50, y:50, width:300, height:500))
        squareBackground.backgroundColor = UIColor.white
        self.view.addSubview(squareBackground)
        
        //        let centerSquare = UIView(frame: CGRect(x: 50, y:50, width: 100, height:100))
        //        centerSquare.backgroundColor = UIColor.black
        //        squareBackground.addSubview(centerSquare)
        
        //        UIView.animate(withDuration: 3.0, animations: {
        //            //            centerSquare.backgroundColor = UIColor.blue
        //            //            let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        //            //            centerSquare.transform = rotation
        //
        //            let expand = CGAffineTransform(scaleX: 2, y: 2 )
        //            centerSquare.transform = expand
        //        })
    }
    
    @IBAction func pressedPlayButton(sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
