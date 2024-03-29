//
//  DLError.swift
//  DokseoLog
//
//  Created by 박제균 on 10/31/23.
//

import Foundation

enum DLError: Error {
  case invalidAPIKey
  case invalidURL
  case invalidResponse
  case invalidData
  case invalidDate
  case noData
  case unableToComplete
  case failToFindData
  case failToSaveData
  case failToFetchData
  case failToDeleteData
  case failToUpdateData
  case duplicatedData
  case noPageInput
  case pageInputInvalid
  case noContentInput

  // MARK: Internal

  var description: String {
    switch self {
    case .invalidAPIKey:
      "API 키가 잘못되었어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidURL:
      "잘못된 URL이에요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidResponse:
      "잘못된 응답이에요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .invalidData:
      "서버로부터 받은 데이터에 오류가 있어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .noData:
      "요청한 데이터가 존재하지 않아요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .unableToComplete:
      "데이터 요청에 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .failToFindData:
      "데이터 찾기에 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .failToSaveData:
      "데이터 저장에 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .failToFetchData:
      "데이터 불러오기에 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .failToDeleteData:
      "데이터 삭제를 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .failToUpdateData:
      "데이터 업데이트에 실패했어요. 개발자에게 문의하거나 다시 시도해 주세요."
    case .duplicatedData:
      "이미 저장된 책이에요."
    case .noPageInput:
      "페이지를 입력해 주세요."
    case .noContentInput:
      "내용을 입력해 주세요."
    case .pageInputInvalid:
      "올바른 페이지 숫자를 입력해 주세요."
    case .invalidDate:
      "잘못된 날짜에요. 개발자에게 문의하거나 다시 시도해 주세요."
    }
  }
}
