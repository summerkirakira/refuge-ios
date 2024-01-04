//
//  UpgradeProperty.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/2.
//

import Foundation

struct ShipUpgradeInfo: Decodable, Encodable {
    let id: Int
    let name: String
    let medias: Media
    let manufacturer: Manufacturer
    let focus: String
    let type: String
    let flyableStatus: String
    let owned: Bool
    let msrp: Int
    let link: String
    let skus: [Sku]?

    struct Media: Decodable, Encodable {
        let productThumbMediumAndSmall: String
        let slideShow: String
    }

    struct Manufacturer: Decodable, Encodable {
        let id: Int
        let name: String
    }

    struct Sku: Decodable, Encodable {
        let id: Int
        let title: String
        let price: Int
    }
}

enum ShipUpgradeType {
    case STANDARD
    case WARBOND
    case SUBSCRIBER
    case OTHER
}

struct UpgradeListItem {
    let skuId: Int
    let shipAlias: ShipAlias?
    let price: Int
    let chineseName: String
    let upgradeName: String
    let detail: ShipUpgradeInfo
    let type: ShipUpgradeType
}


struct FilterShipUpgradeProperty: Decodable {
    let data: Data

    struct Data : Decodable{
        let from: From
        let to: To

        struct From: Decodable{
            let ships: [Ship]

            struct Ship: Decodable{
                let id: Int
            }
        }

        struct To: Decodable{
            let ships: [Ship]

            struct Ship: Decodable {
                let id: Int
                let skus: [Sku]

                struct Sku: Decodable {
                    let id: Int
                    let price: Int
                }
            }
        }
    }
}

struct InitUpgradeProperty: Decodable {
    let data: Data

    struct Data: Decodable {
        let manufacturers: [Manufacturer]
        let ships: [ShipUpgradeInfo]

        struct Manufacturer: Decodable {
            let id: Int
            let name: String
        }
    }
}

let initShipUpgradeQuery = """
query initShipUpgrade {
ships {
  id
  name
  medias {
    productThumbMediumAndSmall
    slideShow
  }
  manufacturer {
    id
    name
  }
  focus
  type
  flyableStatus
  owned
  msrp
  link
  skus {
    id
    title
    available
    price
    body
    unlimitedStock
    availableStock
  }
}
manufacturers {
  id
  name
}
app {
  version
  env
  cookieName
  sentryDSN
  pricing {
    currencyCode
    currencySymbol
    exchangeRate
    taxRate
    isTaxInclusive
  }
  mode
  isAnonymous
  buyback {
    credit
  }
}
}
"""

let filterShipQuery = """
query filterShips($fromId: Int, $toId: Int, $fromFilters: [FilterConstraintValues], $toFilters: [FilterConstraintValues]) {
from(to: $toId, filters: $fromFilters) {
  ships {
    id
  }
}
to(from: $fromId, filters: $toFilters) {
  featured {
    reason
    style
    tagLabel
    tagStyle
    footNotes
    shipId
  }
  ships {
    id
    skus {
      id
      price
      upgradePrice
      unlimitedStock
      showStock
      available
      availableStock
    }
  }
}
}
"""

let searchFromShipQuery = """
query filterShips($fromId: Int, $toId: Int, $fromFilters: [FilterConstraintValues], $toFilters: [FilterConstraintValues]) {
from(to: $toId, filters: $fromFilters) {
  ships {
    id
  }
}
to(from: $fromId, filters: $toFilters) {
  featured {
    reason
    style
    tagLabel
    tagStyle
    footNotes
    shipId
  }
  ships {
    id
    skus {
      id
      price
      upgradePrice
      unlimitedStock
      showStock
      available
      availableStock
    }
  }
}
}
"""

struct SearchFromShipPostBody: Encodable {
    let fromFilters: [String]
    let toFilters: [String]
    let toId: Int?
}

struct InitShipUpgradePostBody: Encodable {
    
}
