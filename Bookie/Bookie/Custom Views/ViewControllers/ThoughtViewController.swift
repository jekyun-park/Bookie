//
//  ThoughtViewController.swift
//  Bookie
//
//  Created by 박제균 on 2/21/24.
//

import UIKit

class ThoughtViewController: UIViewController {

  let book: Book
  let tableView = UITableView()
  var thoughts = [Thought]()

  init(book: Book) {
    self.book = book
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getThoughts()
    configureViewController()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    thoughts.removeAll()
    getThoughts()
    tableView.reloadData()
  }

  private func getThoughts() {
    let result = PersistenceManager.shared.fetchThoughts( self.book)

    switch result {
    case .success(let results):
      thoughts = results
    case .failure(let error):
      self.presentBKAlert(title: "저장된 데이터를 불러올 수 없어요.", message: error.description, buttonTitle: "확인")
    }
  }

  private func configureViewController() {
    view.backgroundColor = .bkBackgroundColor
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func configureTableView() {
    tableView.register(ThoughtTableViewCell.self, forCellReuseIdentifier: ThoughtTableViewCell.reuseID)
    tableView.isScrollEnabled = true
    tableView.separatorStyle = .singleLine
    tableView.showsVerticalScrollIndicator = false

    tableView.backgroundColor = .bkBackgroundColor
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

}

extension ThoughtViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return thoughts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ThoughtTableViewCell.reuseID) as? ThoughtTableViewCell else { return UITableViewCell() }

    let thought = thoughts[indexPath.row]
    cell.setContent(thought: thought)
    cell.separatorInset = UIEdgeInsets.zero
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 600
  }
}

extension ThoughtViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // move to detail view
    // then update data or delete data
    let thought = thoughts[indexPath.row]
    let viewController = ModifyRecordViewController(thought)
//    self.navigationController?.pushViewController(viewController, animated: true)

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootViewController = window.rootViewController as? BKTabBarController {
      let vc = rootViewController.viewControllers?[1] as? UINavigationController
      vc?.pushViewController(viewController, animated: true)
    }
//    let navigationViewController = UINavigationController(rootViewController: viewController)
//    self.present(navigationViewController, animated: true)
  }
}
