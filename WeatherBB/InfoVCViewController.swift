//
//  InfoVCViewController.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/7/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class InfoVCViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //webview.loadRequest(NSURLRequest(URL: NSURL(string: "")! as URL)
        
        webview.loadRequest(NSURLRequest(url: NSURL(string: "https://github.com/mmustafasaeed/WeatherBB/blob/master/README.md")! as URL) as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var backpressed: UINavigationItem!
    
    @IBAction func backButtomPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }


}
