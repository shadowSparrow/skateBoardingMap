//
//  LaunchScreenController.swift
//  Map
//
//  Created by Alexander Romanenko on 09.10.2020.
//  Copyright © 2020 Alexander Romanenko. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    @IBOutlet weak var gorillaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 3.0, animations: {
            self.gorillaImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (Bool) in
            let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            guard let pushToMapVC = storyBoard.instantiateViewController(withIdentifier: "pushToMap"  ) as? SecondMapViewController  else {
                return
            
            }
            self.navigationController?.pushViewController(pushToMapVC, animated: true)
        }
    }
}
