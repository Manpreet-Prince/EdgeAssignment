//
//  ViewController.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import UIKit

class ViewController: UIViewController {

	var selectedIndex = 0
	
	var selectedPeriodIndex = 0
	
	var articleArr : [Parser.Viewed.Article] = []
	
	var filteredArr : [Parser.Viewed.Article] = []
	
	@IBOutlet var articleTV: UITableView!
	
	let searchController = UISearchController(searchResultsController: nil)
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "articleDetailSegue" {
			
			if let nextVC = segue.destination as? DetailViewController {
				
				nextVC.articleObj = filteredArr[selectedIndex]
				
				searchController.isActive = false
			}
		}
	}
	
	// MARK:- Void
	
	func setup() {
		
		self.title = "NY Times"
		
		articleTV.tableFooterView = UIView()
		
		let durationB = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(selectDuration))
		
		self.navigationItem.rightBarButtonItem  = durationB
		
		addSearchBar()
		
		fetchArticles()
	}
	
	func addSearchBar() {
		
		searchController.delegate = self
		
		searchController.searchResultsUpdater = self
		
		searchController.hidesNavigationBarDuringPresentation = false
		
		searchController.obscuresBackgroundDuringPresentation = false
		
		searchController.searchBar.placeholder = "Search Articles"
		
		searchController.searchBar.sizeToFit()
		
		articleTV.tableHeaderView = searchController.searchBar
	}
	
	func fetchArticles() {
		
		APIHelper.shared.fetchArticles(PERIOD_ARR[selectedPeriodIndex]) { (success, arr, errorMsg) in
			
			MAIN_THREAD {
				
				if success {
					
					if let articles = arr {
						
						self.articleArr = articles
						
						self.filteredArr = articles
						
						self.articleTV.reloadData()
					}
					
				} else {
					
					let action = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
					
					action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					
					self.present(action, animated: true, completion: nil)
				}
			}
		}
	}
	
	@objc func selectDuration() {
		
		let action = UIAlertController(title: "", message: "Select duration:", preferredStyle: .actionSheet)
		
		for i in 0...(PERIOD_ARR.count - 1) {
			
			action.addAction(UIAlertAction(title: PERIOD_ARR[i] + " day(s)", style: .default, handler: { _ in
				
				self.selectedPeriodIndex = i
				
				self.fetchArticles()
			}))
		}
		
		action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(action, animated: true, completion: nil)
	}
	
	func filterContentForSearchText(_ searchText: String) {
		
		if searchText.isEmpty {
			
			filteredArr = articleArr
			
		} else {
			
			filteredArr = articleArr.filter{ $0.title.contains(searchText) || $0.byline.contains(searchText) || $0.abstract.contains(searchText) }
		}
		
		articleTV.reloadData()
	}

}

extension ViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		
		filterContentForSearchText(searchController.searchBar.text!)
	}
}

extension ViewController: UISearchControllerDelegate {
	
	func didDismissSearchController(_ searchController: UISearchController) {
		
		filteredArr = articleArr
		
		articleTV.reloadData()
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return filteredArr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
		
		cell.configure(filteredArr[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		selectedIndex = indexPath.row
		
		self.performSegue(withIdentifier: "articleDetailSegue", sender: nil)
	}
}

