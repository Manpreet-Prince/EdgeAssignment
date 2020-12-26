//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

	var articleObj: Parser.Viewed.Article!
	
	@IBOutlet var imageV: UIImageView!
	
	@IBOutlet var collectionL: [UILabel] = []
	
	// MARK:- View LifeCycle
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
		super.viewDidDisappear(animated)
	}
	
	// MARK:- Void
	
	func setup() {
		
		if articleObj.media.count > 0 {
			
			if articleObj.media.last?.media.count ?? 0 > 0 {
				
				if let imageURL = articleObj.media.last?.media.last?.url {
					
					imageV.kf.setImage(with: URL(string: imageURL))
				}
				
			} else {
				
				imageV.image = nil
			}
			
		} else {
			
			imageV.image = nil
		}
		
		collectionL[0].text = articleObj.title
		
		collectionL[1].text = articleObj.byline
		
		collectionL[2].text = articleObj.publishedDate

		collectionL[3].text = articleObj.abstract
		
		let webB = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(goToSource))
		
		self.navigationItem.rightBarButtonItem  = webB
	}
	
	// MARK:- Void
	
	@objc func goToSource() {
		
		let safariVC = SFSafariViewController.init(url: URL(string: articleObj.url)!)
		
		self.present(safariVC, animated: true, completion: nil)
		
		safariVC.delegate = self
	}

}

extension DetailViewController: SFSafariViewControllerDelegate {
	
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		
		self.dismiss(animated: true, completion: nil)
	}
}
