//
//  DataViewController.swift
//  Flickr Test
//
//  Created by Nigel Barber on 01/10/2018.
//  Copyright © 2018 Nigel Barber. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var dataObject: SearchResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let dataObject = dataObject else {
            return
        }
        self.titleLabel!.text = dataObject.title
        self.dateLabel!.text = DateFormatter.localizedString(from: dataObject.dateTaken, dateStyle:.medium, timeStyle:.medium)
        self.authorLabel!.text = dataObject.author
        
        guard let imageData = try? Data(contentsOf: dataObject.imageURL) else {
            return
        }
        imageView!.image = UIImage(data: imageData)
    }


}

