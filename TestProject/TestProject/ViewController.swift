//
//  ViewController.swift
//  TestProject
//
//  Created by Godjira on 9/11/18.
//  Copyright © 2018 Godjira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    var linkArray: [[String: [String: String]]] = []
    var countAllLinks = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        tableView.tableFooterView = footerView

        activityIndicatior?.hidesWhenStopped = true
      activityIndicatior?.stopAnimating()
        tableView.rowHeight = 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func parseAction(_ sender: Any) {
        activityIndicatior?.startAnimating()
        linkArray = []
        let links = textView.text.split(separator: "\n")
        countAllLinks = links.count
        for link in links {
            parse(urlString: String(link))
        }
    }
    
    func parse(urlString: String) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard data != nil else {
                return
            }
            let htmlString = String(data: data!, encoding: .utf8)
            let titleString = htmlString?.slice(from: "<title>", to: "/title")
            DispatchQueue.main.async {
                guard let titleString = titleString else {
                    self.countAllLinks = self.countAllLinks - 1
                    return }
                guard let htmlString = htmlString else {
                    self.countAllLinks = self.countAllLinks - 1
                    return }
                self.linkArray.append([urlString: [titleString: htmlString]])
                self.tableView.reloadData()
                if self.linkArray.count == self.countAllLinks {
                    self.activityIndicatior?.stopAnimating()
                }
            }
        }
        task.resume()
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? =
            tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .default,
                                   reuseIdentifier: "cell")
        }
        
        let linkDic = linkArray[indexPath.row].values.first
        cell?.textLabel?.text = linkDic?.keys.first
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.link = linkArray[indexPath.row].keys.first
        self.present(webVC, animated: true)
    }
    
}

