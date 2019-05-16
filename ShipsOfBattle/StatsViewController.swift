//
//  StatsViewController.swift
//  ShipsOfBattle
//
//  Created by Davis Robeson on 5/15/19.
//  Copyright © 2019 trey. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet var hitsLabel: UILabel!
    @IBOutlet var missLabel: UILabel!
    @IBOutlet var hitRateLabel: UILabel!
    
    var hits: Int!
    var misses: Int!
    var hitRate: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hitsLabel.text = "Hits: \(hits ?? 00)"
        missLabel.text = "Misses: \(misses ?? 00)"
        hitRateLabel.text = "Hit %: \(hitRate ?? 00)%"
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
