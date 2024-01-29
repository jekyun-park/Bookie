//
//  BookInformationViewController.swift
//  Bookie
//
//  Created by 박제균 on 1/8/24.
//

import UIKit

class BookInformationViewController: UIViewController {

  let book: Book
  
  private lazy var scrollView = UIScrollView(frame: .zero)
  private lazy var titleLabel = BKTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .bold)
  private lazy var authorLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private lazy var introduceLabel = BKTitleLabel(textAlignment: .left, fontSize: 15, fontWeight: .medium)
  private lazy var pageLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
  private lazy var descriptionLabel = BKBodyLabel(textAlignment: .left, fontSize: 15, fontWeight: .regular)
  private lazy var coverImage = BKCoverImageView(frame: .zero)
  private lazy var addToBasketBarButton = UIBarButtonItem(image: Images.basketBarButtonImage, style: .plain, target: self, action: #selector(addToBasketBarButtonTapped))
  private lazy var addBookBarButton = UIBarButtonItem(image: Images.addBookBarButtonImage, style: .plain, target: self, action: #selector(addBookBarButtonTapped))

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(book: Book) {
    self.book = book
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureScrollView()
    configureNavigationBar()
    setupUI()
    }

  private func setupUI() {
    titleLabel.text = book.title
    authorLabel.text = book.author
    descriptionLabel.text = book.description
    descriptionLabel.adjustsFontSizeToFitWidth = false
    introduceLabel.text = "책소개"
    if let page = book.subInfo?.itemPage {
      pageLabel.text = "\(page)p"
    } else {
      pageLabel.text = "페이지 정보 없음"
    }

    coverImage.downloadImage(fromURL: book.coverURL)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      view.centerXAnchor.constraint(equalTo: coverImage.centerXAnchor),
      coverImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
      coverImage.widthAnchor.constraint(equalToConstant: 150),
      coverImage.heightAnchor.constraint(equalToConstant: 225),

      titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 40),
      titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      authorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      pageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
      pageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),

      introduceLabel.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 30),
      introduceLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),

      descriptionLabel.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor),
      descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
      descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

    ])

  }

  private func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubviews(titleLabel, authorLabel, descriptionLabel, introduceLabel, pageLabel, coverImage)
    scrollView.backgroundColor = .bkBackground
    scrollView.isScrollEnabled = true
  }

  private func configureNavigationBar() {
    self.navigationItem.setRightBarButtonItems([addToBasketBarButton, addBookBarButton], animated: true)
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.tintColor = .bkTabBarTint
    addToBasketBarButton.tintColor = .bkTabBarTint
    addBookBarButton.tintColor = .bkTabBarTint
  }

  @objc private func addToBasketBarButtonTapped() {
    print("button tapped")
  }

  @objc private func addBookBarButtonTapped() {
    print("button tapped")
  }

}