//
//  ModifyRecordViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2/23/24.
//

import Toast
import UIKit

// MARK: - ModifyRecordViewController

class ModifyRecordViewController: UIViewController {

  // MARK: Lifecycle

  init(sentence: Sentence, style: ModifyRecordViewController.ViewStyle) {
    self.sentence = sentence
    thought = nil
    recordStyle = .sentence
    viewStyle = style
    super.init(nibName: nil, bundle: nil)
  }

  init(thought: Thought, style: ModifyRecordViewController.ViewStyle) {
    sentence = nil
    self.thought = thought
    recordStyle = .thought
    viewStyle = style
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let sentence: Sentence?
  let thought: Thought?
  let recordStyle: ModifyRecordViewController.RecordStyle
  let viewStyle: ModifyRecordViewController.ViewStyle

  var book: Book? {
    if let book = self.sentence?.book {
      return book
    } else if let book = self.thought?.book {
      return book
    }
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .dlBackground
    setupNavigationController()
    recordStyle == .sentence ? setupSentenceUI() : setupThoughtUI()
    hideKeyboardWhenTappedAround()
  }

  // MARK: Private

  private lazy var pageTextField: DLTextField = {
    let textField = DLTextField(frame: .zero)
    textField.text = String(self.sentence?.page ?? 0)
    return textField
  }()

  private lazy var pagePlaceholderLabel: DLTitleLabel = {
    let label = DLTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "페이지"
    return label
  }()

  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.backgroundColor = .tertiarySystemBackground
    textView.text = self.recordStyle.placeHolderString
    textView.delegate = self
    textView.autocorrectionType = .no
    textView.spellCheckingType = .no
    textView.font = UIFont(name: Fonts.HanSansNeo.medium.description, size: 15)
    textView.textColor = .label
    textView.layer.cornerRadius = 5
    textView.layer.borderColor = UIColor.systemGray4.cgColor
    textView.layer.borderWidth = 0.8
    switch self.recordStyle {
    case .sentence:
      textView.text = self.sentence?.memo
    case .thought:
      textView.text = self.thought?.memo
    }
    return textView
  }()

  private lazy var sentencePlaceholderLabel: DLTitleLabel = {
    let label = DLTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "문장 수집하기"
    return label
  }()

  private lazy var thoughtPlaceholderLabel: DLTitleLabel = {
    let label = DLTitleLabel(textAlignment: .left, fontSize: 17, fontWeight: .medium)
    label.text = "내 생각 적기"
    return label
  }()

  private lazy var deleteButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: Images.trashImage,
      style: .plain,
      target: self,
      action: #selector(deleteButtonTapped))
    button.tintColor = .red
    return button
  }()

  private lazy var updateButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      title: "수정",
      style: .done,
      target: self,
      action: #selector(updateButtonTapped))
    button.tintColor = .dlTabBarTintColor
    return button
  }()

  private lazy var bookInformationButton = UIBarButtonItem(
    image: Images.infoImage,
    style: .plain,
    target: self,
    action: #selector(bookInformationButtonTapped))

  private func setupSentenceUI() {
    switch viewStyle {
    case .withBookInformation:
      navigationItem.rightBarButtonItems = [deleteButton, updateButton, bookInformationButton]
    case .withoutBookInformation: break
    }

    let padding: CGFloat = 20
    view.addSubviews(pageTextField, pagePlaceholderLabel, sentencePlaceholderLabel, textView)
    NSLayoutConstraint.activate([
      pagePlaceholderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      pagePlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      pagePlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      pageTextField.topAnchor.constraint(equalTo: pagePlaceholderLabel.bottomAnchor, constant: padding),
      pageTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      pageTextField.heightAnchor.constraint(equalToConstant: 50),
      pageTextField.widthAnchor.constraint(equalToConstant: 100),

      sentencePlaceholderLabel.topAnchor.constraint(equalTo: pageTextField.bottomAnchor, constant: padding),
      sentencePlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      sentencePlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      textView.topAnchor.constraint(equalTo: sentencePlaceholderLabel.bottomAnchor, constant: padding),
      textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
      textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
    ])
  }

  private func setupThoughtUI() {
    switch viewStyle {
    case .withBookInformation:
      navigationItem.rightBarButtonItems = [deleteButton, updateButton, bookInformationButton]
    case .withoutBookInformation: break
    }
    let padding: CGFloat = 20
    view.addSubviews(thoughtPlaceholderLabel, textView)
    NSLayoutConstraint.activate([
      thoughtPlaceholderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      thoughtPlaceholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      thoughtPlaceholderLabel.heightAnchor.constraint(equalToConstant: padding),

      textView.topAnchor.constraint(equalTo: thoughtPlaceholderLabel.bottomAnchor, constant: padding),
      textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
      textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
    ])
  }

  private func setupNavigationController() {
    navigationItem.rightBarButtonItems = [deleteButton, updateButton]
    navigationController?.navigationItem.backButtonDisplayMode = .minimal
    navigationItem.leftBarButtonItem = .none
  }

  @objc
  private func updateButtonTapped() {
    switch recordStyle {
    case .sentence:
      guard let pageString = pageTextField.text, !pageString.isEmpty else {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemGreen
        view.makeToast(DLError.noPageInput.description, duration: 1, position: .center, style: style)
        return
      }

      if (textView.text == recordStyle.placeHolderString) || textView.text.isEmpty {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemGreen
        view.makeToast(DLError.noContentInput.description, duration: 1, position: .center, style: style)
        return
      }

      guard let page = Int(pageString) else {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        view.makeToast(DLError.pageInputInvalid.description, duration: 1, position: .center, style: style)
        return
      }

      let sentence = Sentence(
        book: sentence!.book,
        page: page,
        memo: textView.text,
        id: sentence!.id,
        createdAt: sentence!.createdAt)

      let update = PersistenceManager.shared.updateSentence(sentence)

      switch update {
      case .success:
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemGreen
        view.makeToast("수정되었습니다.", duration: 1, position: .center, style: style) { _ in
          self.navigationController?.popViewController(animated: true)
        }
      case .failure(let error):
        presentDLAlert(title: "저장에 실패했어요.", message: error.description , buttonTitle: "확인")
        return
      }

    case .thought:
      if (textView.text == recordStyle.placeHolderString) || textView.text.isEmpty {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        view.makeToast(DLError.noContentInput.description, duration: 1, position: .center, style: style)
        return
      }

      let thought = Thought(book: thought!.book, memo: textView.text, id: thought!.id, createdAt: thought!.createdAt)
      let update = PersistenceManager.shared.updateThought(thought)

      switch update {
      case .success:
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemGreen
        view.makeToast("수정되었습니다.", duration: 1, position: .center, style: style) { _ in
          self.navigationController?.popViewController(animated: true)
        }
      case .failure(let error):
        presentDLAlert(title: "저장에 실패했어요.", message: error.description , buttonTitle: "확인")
        return
      }
    }
  }

  @objc
  private func deleteButtonTapped() {
    switch recordStyle {
    case .sentence:
      presentDLAlertWithDestructiveAction(title: "정말 삭제할까요?", message: "수집한 문장을 삭제합니다.", buttonTitle: "삭제") {
        let result = PersistenceManager.shared.deleteSentence(self.sentence!)
        switch result {
        case .success:
          var style = ToastStyle()
          style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
          style.backgroundColor = .systemGreen
          self.view.makeToast("삭제되었습니다.", duration: 1, position: .center, style: style) { _ in
            self.navigationController?.popViewController(animated: true)
          }
        case .failure(let error):
          self.presentDLAlert(title: "문장을 삭제하지 못했어요.", message: error.description, buttonTitle: "확인")
        }
      }
    case .thought:
      presentDLAlertWithDestructiveAction(title: "정말 삭제할까요?", message: "기록을 삭제합니다.", buttonTitle: "삭제") {
        let result = PersistenceManager.shared.deleteThought(self.thought!)
        switch result {
        case .success:
          var style = ToastStyle()
          style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
          style.backgroundColor = .systemGreen
          self.view.makeToast("삭제되었습니다.", duration: 1, position: .center, style: style) { _ in
            self.navigationController?.popViewController(animated: true)
          }
        case .failure(let error):
          self.presentDLAlert(title: "기록을 삭제하지 못했어요.", message: error.description, buttonTitle: "확인")
        }
      }
    }
  }

  @objc
  private func bookInformationButtonTapped() {
    if let book {
      navigationController?.pushViewController(BookInformationViewController(book: book, style: .add), animated: true)
    } else {
      presentDLAlert(title: "책 정보를 찾지 못했어요.", message: DLError.failToFindData.description, buttonTitle: "확인")
    }
  }

}

// MARK: ModifyRecordViewController.style

extension ModifyRecordViewController {

  enum RecordStyle {
    case sentence, thought

    var placeHolderString: String {
      switch self {
      case .sentence:
        "인상깊었던 문장을 입력하세요"
      case .thought:
        "책을 읽으며 했던 생각이나 느꼈던 감정을 입력하세요"
      }
    }
  }

  enum ViewStyle {
    case withBookInformation, withoutBookInformation
  }
}

// MARK: UITextViewDelegate

extension ModifyRecordViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == recordStyle.placeHolderString {
      textView.text = nil
      textView.textColor = .label
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = recordStyle.placeHolderString
      textView.textColor = .lightGray
    }
  }

}
