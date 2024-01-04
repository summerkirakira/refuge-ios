//
//  UpgradeFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/3.
//

import Foundation

func initShipUpgrade(rsiAPI: RSIApi = RsiApi) async -> InitUpgradeProperty? {
    let result = await rsiAPI.initShipUpgrade()
    return result
}

func getUpgradeFromShip(rsiAPI: RSIApi = RsiApi, toShipId: Int?) async -> FilterShipUpgradeProperty? {
    let result = await rsiAPI.getUpgradeFromShip(toShipId: toShipId)
    return result
}

func buyUpgrade(rsiAPI: RSIApi = RsiApi, fromSkuId: Int, toSkuId: Int, number: Int) async -> String? {
    let addCartResult = await rsiAPI.addUpgradeToCart(fromSkuId: fromSkuId, toSkuId: toSkuId)
    if addCartResult == nil {
        return "添加购物车失败"
    }
    if addCartResult!.data.addToCart == nil {
        return "添加购物车失败"
    }
    let jwt = addCartResult!.data.addToCart!.jwt
    let applyTokenResult = await rsiAPI.applyCartToken(jwt: jwt)
    if applyTokenResult == nil {
        return "应用Token失败"
    }
    if applyTokenResult!.success == 0 {
        return "应用Token失败"
    }
    let cartSummary = await rsiAPI.getCartSummary()
    if cartSummary == nil {
        return "获取订单信息失败"
    }
    if cartSummary!.errors != nil {
        return "获取订单信息失败"
    }
    let availableCredit = cartSummary!.data.store.cart.totals.credits.maxApplicable - cartSummary!.data.store.cart.totals.credits.amount
    
    if availableCredit < 0 {
        return "信用点不足哦"
    }
    
    let applyCreditResult = await rsiAPI.addCredit(amount: Float(availableCredit) / 100)
    
    if applyCreditResult == nil {
        return "添加信用点失败"
    }
    
    if applyCreditResult!.error != nil {
        return "添加信用点失败"
    }
    
    let nextStepResult = await rsiAPI.nextStep()
    
    if nextStepResult == nil {
        return "跳转到第二步失败"
    }
    
    if nextStepResult!.error != nil {
        return "跳转到第二步失败"
    }
    
    let addressInfo = await rsiAPI.cartAddressQuery()
    if addressInfo == nil {
        return "获取订单地址失败"
    }
    if addressInfo!.data.store.addressBook.count == 0 {
        return "请先在网页端添加至少一个订单地址哦"
    }
    
    let billing = addressInfo!.data.store.addressBook[0].id
    
    let assignAddress = await rsiAPI.cartAddressAssign(billing: billing)
    
    if assignAddress == nil {
        return "应用订单地址失败"
    }
    
    let cartValidation = await rsiAPI.cartValidate()
    
    if cartValidation == nil {
        return "确认订单地址失败"
    }
    
    if cartValidation!.error != nil {
        return "确认订单地址失败"
    }
    
    let finalCartStatus = await rsiAPI.getCartSummary()
    
    if finalCartStatus == nil {
        return "获取最终订单信息失败"
    }
    
    if finalCartStatus!.data.store.cart.totals.total == 0 && finalCartStatus!.data.store.cart.totals.subTotal == 0 {
        return nil
    } else {
        return "信用点不足哦~"
    }
    
    
    return "未知错误"
}
