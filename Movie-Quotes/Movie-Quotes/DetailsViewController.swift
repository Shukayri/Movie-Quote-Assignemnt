//
//  DetailsViewController.swift
//  Movie-Quotes
//
//  Created by administrator on 1/10/22.
//

import UIKit


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    let defaulteLink = "https://api.opendota.com"
    var names : String?
    var imgurl :String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let ln = defaulteLink + imgurl!
        name.text = "\(names!)"
        img.downloaded(from: ln)

       
    }

}
