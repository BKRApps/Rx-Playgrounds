//
//  ViewController.swift
//  Rx-Playgrounds
//
//  Created by Birapuram Kumar Reddy on 1/12/18.
//  Copyright © 2018 KRiOSApps. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let sb = UIStoryboard(name: "GitFeed", bundle: Bundle.main)
        let gitfeedController = sb.instantiateInitialViewController() as! GitFeedViewController
        self.navigationController?.pushViewController(gitfeedController, animated: true)
    }

}

