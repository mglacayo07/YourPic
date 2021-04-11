//
//  ZoomViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit
import Firebase

class ZoomViewController: UIViewController {

    @IBOutlet weak var zoomImage: UIImageView!
    
    var ref: [StorageReference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear \(ref)")
        zoomImage.sd_setImage(with: ref[0], placeholderImage: UIImage(named: "notfound.png"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
}
