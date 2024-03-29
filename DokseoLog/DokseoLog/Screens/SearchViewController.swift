//
//  SearchViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 11/10/23.
//

import UIKit

// MARK: - SearchViewController

class SearchViewController: DLLoadingViewController {

  // MARK: Internal

  let tableView = UITableView()
  let searchController = UISearchController()
  var results: [BookDTO] = []
  var totalSearchResults = 0
  var hasMoreSearchResults = false
  var page = 1

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureTableView()
    hideKeyboardWhenTappedAround()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  func updateUI(with books: [BookDTO]) {
    results.append(contentsOf: books)
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.view.bringSubviewToFront(self.tableView)
    }
  }

  // MARK: Private

  private func requestSearchResults(for string: String, page: Int) {
    showLoadingView()
    NetworkManager.shared.searchBookInformation(for: string, page: page) { [weak self] result in
      guard let self else { return }
      dismissLoadingView()
      switch result {
      case .success(let searchResult):
        totalSearchResults = searchResult.totalResults
        results.count < totalSearchResults ? (hasMoreSearchResults = true) : (hasMoreSearchResults = false)
        updateUI(with: searchResult.books)
      case .failure(let error):
        DispatchQueue.main.async {
          self.presentDLAlert(title: "검색결과를 불러올 수 없어요.", message: error.description, buttonTitle: "확인")
        }
      }
    }
  }

  private func configureViewController() {
    view.backgroundColor = .dlBackgroundColor
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.font: UIFont(
        name: Fonts.HanSansNeo.medium.description,
        size: 18)!,
    ]
  }

  private func configureSearchController() {
    searchController.searchBar.tintColor = .dlTabBarTint
    searchController.searchBar.delegate = self
    searchController.searchBar.isHidden = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "책 제목, 저자를 검색해보세요"
    navigationItem.searchController = searchController
  }

  private func configureTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.backgroundColor = .dlBackgroundColor
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .systemGray
    tableView.separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
    tableView.rowHeight = 165
    tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
  }

}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchString = searchBar.text else { return }
    results.removeAll()
    requestSearchResults(for: searchString, page: page)
  }

  func searchBarCancelButtonClicked(_: UISearchBar) {
    page = 0
    totalSearchResults = 0
    results.removeAll()
    tableView.reloadData()
  }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID) as? SearchResultCell
    else { return UITableViewCell() }
    let searchResult = results[indexPath.row]
    cell.setContents(book: searchResult)
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    let bookInformation = results[indexPath.row]

    NetworkManager.shared.fetchBookDetailInformation(with: bookInformation.isbn13) { [weak self] result in
      switch result {
      case .success(let bookDTO):
        DispatchQueue.main.async {
          guard let self else { return }
          self.navigationController?.pushViewController(
            BookInformationViewController(book: bookDTO.toModel(), style: .add),
            animated: true)
        }
      case .failure(let error):
        guard let self else { return }
        presentDLAlert(title: "도서 정보를 불러올 수 없어요.", message: error.description, buttonTitle: "확인")
      }
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height

    if offsetY > contentHeight - height {
      if hasMoreSearchResults {
        page += 1
        guard let text = searchController.searchBar.text else { return }
        requestSearchResults(for: text, page: page)
      }
    }
  }

}
