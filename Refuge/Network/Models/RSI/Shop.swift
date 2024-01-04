//
//  Shop.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/4.
//

import Foundation

struct ApplyCartTokenPostBody: Encodable {
    let jwt: String
}

struct ApplyCartTokenProperty: Decodable {
    let success: Int
    let message: String?
}

let CartSummaryViewMutationQuery = """
query CartSummaryViewQuery($storeFront: String) {
  account {
    isAnonymous
    __typename
  }
  store(name: $storeFront) {
    cart {
      totals {
        ...TyCartTotalFragment
        __typename
      }
      __typename
    }
    ...CartFlowFragment
    __typename
  }
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

struct CartSummaryViewMutationPostBody: Encodable {
    var storeFront: String = "pledge"
}

struct CartSummaryProperty: Decodable {
    let errors: [Error]?
    let data: CartData
    
    struct Error: Decodable {
        let message: String
        let extensions: Extensions

        struct Extensions: Decodable {
            let code: Int?
            let details: Details?

            struct Details: Decodable {
                let amount: String?
            }
        }
    }

    struct CartData: Decodable {
        let account: Account
        let store: Store

        struct Account: Decodable {
            let isAnonymous: Bool
        }

        struct Store: Decodable {
            let cart: Cart

            struct Cart: Decodable {
                let totals: Totals

                struct Totals: Decodable {
                    let discount: Int
                    let shipping: Int
                    let total: Int
                    let subTotal: Int
                    let tax1: Tax
                    let tax2: Tax
                    let credits: Credits

                    struct Tax: Decodable {
                        let amount: Int
                        let name: String?
                    }

                    struct Credits: Decodable {
                        let amount: Int
                        let nativeAmount: NativeAmount?
                        let applicable: Bool
                        let maxApplicable: Int

                        struct NativeAmount: Decodable {
                            let value: Int
                        }
                    }
                }
            }
        }
    }
}

let AddCreditQuery = """
mutation AddCreditMutation($amount: Float!, $storeFront: String) {
  store(name: $storeFront) {
    cart {
      mutations {
        credit_update(amount: $amount)
        __typename
      }
      __typename
    }
    ...EntityAfterUpdateFragment
    __typename
  }
}

fragment EntityAfterUpdateFragment on TyStore {
  ...CartFlowFragment
  ...OrderSlugFragment
  cart {
    lineItemsQties
    billingRequired
    shippingRequired
    totals {
      ...TyCartTotalFragment
      __typename
    }
    lineItems {
      ...TySkuFragment
      id
      skuId
      identifier
      taxDescription
      discounts {
        ...TyCartLineItemDiscountFragment
        __typename
      }
      unitPriceWithTax {
        amount
        discounted
        __typename
      }
      qty
      ... on ShipCustomizationLineItem {
        customizationId
        __typename
      }
      ... on ShipUpgradeLineItem {
        upgrade {
          name
          fromShipId
          toShipId
          toSkuId
          thumbnail
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
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

fragment OrderSlugFragment on TyStore {
  order {
    slug
    __typename
  }
  __typename
}

fragment TySkuFragment on TyCartLineItem {
  sku {
    id
    productId
    title
    label
    subtitle
    url
    type
    frequency
    isWarbond
    isPackage
    gameItems {
      ... on ShipGameItem {
        specs {
          productionStatus
          __typename
        }
        __typename
      }
      __typename
    }
    stock {
      ...TyStockFragment
      __typename
    }
    media {
      thumbnail {
        storeSmall
        __typename
      }
      __typename
    }
    maxQty
    minQty
    publicType {
      code
      label
      __typename
    }
    nativePrice {
      amount
      discounted
      __typename
    }
    price {
      amount
      discounted
      taxDescription
      __typename
    }
    __typename
  }
  __typename
}

fragment TyStockFragment on TyStock {
  unlimited
  show
  available
  backOrder
  qty
  backOrderQty
  level
  __typename
}

fragment TyCartLineItemDiscountFragment on TyCartLineItemDiscount {
  id
  title
  type
  reduction
  details
  bundle {
    id
    title
    __typename
  }
  __typename
}
"""

struct AddCreditPostBody: Encodable {
    let amount: Float
    let storeFront: String = "pledge"
}

struct AddCreditProperty: Decodable {
    let error: [Error]?
    
    struct Error: Decodable {
        let message: String
        let extensions: Extensions

        struct Extensions: Decodable {
            let code: Int?
            let details: Details?

            struct Details: Decodable {
                let amount: String?
            }
        }
    }
}

let ClearCartQuery = """
mutation ClearCartMutation($storeFront: String) {
store(name: $storeFront) {
  cart {
    mutations {
      clear
      __typename
    }
    __typename
  }
  ...EntityAfterUpdateFragment
  __typename
}
}

fragment EntityAfterUpdateFragment on TyStore {
...CartFlowFragment
...OrderSlugFragment
cart {
  lineItemsQties
  billingRequired
  shippingRequired
  totals {
    ...TyCartTotalFragment
    __typename
  }
  lineItems {
    ...TySkuFragment
    id
    skuId
    identifier
    taxDescription
    discounts {
      ...TyCartLineItemDiscountFragment
      __typename
    }
    unitPriceWithTax {
      amount
      discounted
      __typename
    }
    qty
    ... on ShipCustomizationLineItem {
      customizationId
      __typename
    }
    ... on ShipUpgradeLineItem {
      upgrade {
        name
        fromShipId
        toShipId
        toSkuId
        thumbnail
        __typename
      }
      __typename
    }
    __typename
  }
  __typename
}
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

fragment OrderSlugFragment on TyStore {
order {
  slug
  __typename
}
__typename
}

fragment TySkuFragment on TyCartLineItem {
sku {
  id
  productId
  title
  label
  subtitle
  url
  type
  isWarbond
  isPackage
  stock {
    ...TyStockFragment
    __typename
  }
  media {
    thumbnail {
      storeSmall
      __typename
    }
    __typename
  }
  maxQty
  minQty
  publicType {
    code
    label
    __typename
  }
  nativePrice {
    amount
    discounted
    __typename
  }
  price {
    amount
    discounted
    taxDescription
    __typename
  }
  __typename
}
__typename
}

fragment TyStockFragment on TyStock {
unlimited
show
available
backOrder
qty
backOrderQty
level
__typename
}

fragment TyCartLineItemDiscountFragment on TyCartLineItemDiscount {
id
title
type
reduction
details
bundle {
  id
  title
  __typename
}
__typename
}
"""

struct ClearCartPostBody: Encodable {
    let storeFront: String = "pledge"
}

struct BasicCartProperty: Decodable {
    let error: [Error]?
    
    struct Error: Decodable {
        let message: String
        let extensions: Extensions

        struct Extensions: Decodable {
            let code: Int?
            let details: Details?

            struct Details: Decodable {
                let amount: String?
            }
        }
    }
}

struct ClearCartProperty: Decodable {
    let error: [Error]?
    
    struct Error: Decodable {
        let message: String
        let extensions: Extensions

        struct Extensions: Decodable {
            let code: Int?
            let details: Details?

            struct Details: Decodable {
                let amount: String?
            }
        }
    }
}

let NextStepQuery = """
mutation NextStepMutation($storeFront: String) {
store(name: $storeFront) {
  cart {
    hasDigital
    mutations {
      flow {
        moveNext
        __typename
      }
      __typename
    }
    totals {
      ...TyCartTotalFragment
      __typename
    }
    __typename
  }
  ...CartFlowFragment
  ...OrderSlugFragment
  __typename
}
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

fragment OrderSlugFragment on TyStore {
order {
  slug
  __typename
}
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

struct NextStepPostBody: Encodable {
    let storeFront: String = "pledge"
}

let CartValidationMutationQuery = """
mutation CartValidateCartMutation($storeFront: String, $token: String, $mark: String) {
store(name: $storeFront) {
  cart {
    mutations {
      validate(mark: $mark, token: $token)
      __typename
    }
    __typename
  }
  ...CartFlowFragment
  ...OrderSlugFragment
  __typename
}
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

fragment OrderSlugFragment on TyStore {
order {
  slug
  __typename
}
__typename
}
"""

struct CartValidationMutationPostBody: Encodable {
    let storeFront: String="pledge"
    let token: String
    let mark: String
}
