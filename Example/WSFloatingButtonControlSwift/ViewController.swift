//
//  ViewController.swift
//  WSFloatingButtonControlSwift
//
//  Created by WebsoftProfession on 02/13/2023.
//  Copyright (c) 2023 WebsoftProfession. All rights reserved.
//

import UIKit
import WSFloatingButtonControlSwift

class ViewController: UIViewController {
    
    @IBOutlet var floatingButton: WSFloatingControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        floatingButton.image = "icon_close"
        //        floatingButton.radiousColor = .black
                floatingButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: WSFloatingButtonDelegate {
    func viewsForFloatingButtonOptions() -> [WSFloatingOption] {
        return [WSFloatingOption.init(width: 60, title: "Home", image: "icon_rec"), WSFloatingOption.init(width: 60, title: "", image: "icon_rec"), WSFloatingOption.init(width: 60, title: "", image: "icon_rec"), WSFloatingOption.init(width: 60, title: "", image: "icon_rec"), WSFloatingOption.init(width: 60, title: "", image: "icon_rec")]
    }
    
    
    func floatingButtonDidToggle(isOpened: Bool) {
        
    }
    
    func floatingOptionDidTapped(option: WSFloatingOption) {
        
    }
}



