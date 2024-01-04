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
    
    func getHighestSku() -> Sku? {
        if self.skus == nil {
            return nil
        }
        if self.skus!.count == 0 {
            return nil
        }
        let sortedSku = self.skus!.sorted {
            return $0.price < $1.price
        }
        return sortedSku[0]
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

struct AddUpgradeToCartProperty: Decodable {
    let data: Data

    struct Data: Decodable {
        let addToCart: AddToCart?

        struct AddToCart: Decodable {
            let jwt: String
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

let UpgradeAddToCartQuery = """
mutation addToCart($from: Int!, $to: Int!) {
addToCart(from: $from, to: $to) {
  jwt
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

struct UpgradeAddToCartPostBody: Encodable {
    let from: Int
    let to: Int
}

let AdressBookQuery = """
query AddressBookQuery($storeFront: String) {
store(name: $storeFront) {
  addressBook {
    ...TyAddressFragment
    __typename
  }
  cart {
    lineItems {
      id
      sku {
        id
        stock {
          unlimited
          backOrder
          __typename
        }
        __typename
      }
      __typename
    }
    totals {
      ...TyCartTotalFragment
      __typename
    }
    shippingAddress {
      ...PostalAddressFragment
      __typename
    }
    billingAddress {
      ...PostalAddressFragment
      __typename
    }
    shippingRequired
    billingRequired
    __typename
  }
  __typename
}
}

fragment TyAddressFragment on TyAddress {
id
defaultBilling
defaultShipping
company
firstname
lastname
addressLine
postalCode
phone
city
country {
  id
  name
  requireRegion
  hasRegion
  code
  __typename
}
region {
  id
  code
  name
  __typename
}
__typename
}

fragment PostalAddressFragment on PostalAddress {
id
firstname
lastname
addressLine
city
company
phone
postalCode
regionName
countryName
countryCode
__typename
}

fragment TyCartTotalFragment on TyCartTotal {
discount
shipping
total
subTotal
tax1 {
  name
  amount
  __typename
}
tax2 {
  name
  amount
  __typename
}
coupon {
  amount
  allowed
  code
  __typename
}
credits {
  amount
  nativeAmount {
    value
    __typename
  }
  applicable
  maxApplicable
  __typename
}
__typename
}
"""

struct AddressBookPostBody: Encodable {
    let storeFront: String = "pledge"
}

struct CartAddressProperty: Decodable {
    let data: Data

    struct Data: Decodable {
        let store: Store

        struct Store: Decodable {
            let addressBook: [AddressBook]

            struct AddressBook: Decodable {
                let id: String
            }
        }
    }
}

let CartAddressAssignMutationQuery = """
mutation CartAddressAssignMutation($billing: ID, $shipping: ID, $storeFront: String) {
  store(name: $storeFront) {
    cart {
      mutations {
        assignAddresses(assign: {billing: $billing, shipping: $shipping})
        __typename
      }
      shippingAddress {
        ...PostalAddressFragment
        __typename
      }
      billingAddress {
        ...PostalAddressFragment
        __typename
      }
      totals {
        ...TyCartTotalFragment
        __typename
      }
      __typename
    }
    context {
      currencies {
        code
        symbol
        __typename
      }
      pricing {
        ...PricingContextFragment
        __typename
      }
      __typename
    }
    ...CartFlowFragment
    __typename
  }
}

fragment PricingContextFragment on PricingContext {
  currencyCode
  currencySymbol
  exchangeRate
  taxInclusive
  __typename
}

fragment PostalAddressFragment on PostalAddress {
  id
  firstname
  lastname
  addressLine
  city
  company
  phone
  postalCode
  regionName
  countryName
  countryCode
  __typename
}

fragment TyCartTotalFragment on TyCartTotal {
  discount
  shipping
  total
  subTotal
  tax1 {
    name
    amount
    __typename
  }
  tax2 {
    name
    amount
    __typename
  }
  coupon {
    amount
    allowed
    code
    __typename
  }
  credits {
    amount
    nativeAmount {
      value
      __typename
    }
    applicable
    maxApplicable
    __typename
  }
  __typename
}

fragment CartFlowFragment on TyStore {
  cart {
    flow {
      steps {
        step
        action
        finalStep
        active
        __typename
      }
      current {
        orderCreated
        __typename
      }
      __typename
    }
    __typename
  }
  __typename
}
"""

struct CartAddressAssignMutationPostBody: Encodable {
    let storeFront: String = "pledge"
    let billing: String
}
