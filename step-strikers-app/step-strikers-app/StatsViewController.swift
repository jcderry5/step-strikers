//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/13/23.
//

import UIKit

class StatsViewController: UIViewController {
    var delegate: DamageViewController!
    
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerOneHealth: UILabel!
    
    
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerTwoHealth: UILabel!
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
