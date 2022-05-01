//
//  MagnetPresentMenuSection.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import Foundation
import RxDataSources

///After Refactoring
enum PresentMenuSectionModel {
    case SectionMainTitle(items: [PresentMenuTitleItem])
    case SectionMenu(header: String, canSelectCount: Int?, items: [PresentMenuItem])
    case SectionSelectCount(items: [PresentSelectCountItem])
}

protocol PresentMenuSectionItem {
    
}

struct PresentMenuItem: PresentMenuSectionItem {
    var title: String?
    var description: String?
    var price: Int?
    var thumbnail: String?
}

struct PresentMenuTitleItem: PresentMenuSectionItem {
    var imageUrl: String?
    var mainTitle: String
}

struct PresentSelectCountItem: PresentMenuSectionItem {
    var title: String?
}

extension PresentMenuSectionModel: SectionModelType {
    typealias Item = PresentMenuSectionItem
    
    init(original: PresentMenuSectionModel, items: [PresentMenuSectionItem]) {
        self = original
    }

    var headers: String? {
        switch self {
        case .SectionMenu(let header, _, _):
            return header
        default:
            return nil
        }
    }
    
    var canSelectCount: Int? {
        switch self {
        case .SectionMenu(_, let count, _):
            return count
        default:
            return nil
        }
    }
    
  var items: [Item] {
      switch self {
      case .SectionMainTitle(let items):
          return items
      case .SectionMenu(_, _, let items):
          return items
      case.SectionSelectCount(let items):
          return items
      }
  }
}
