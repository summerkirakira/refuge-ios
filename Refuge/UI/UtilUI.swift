//
//  Utils.swift
//  Refuge
//
//  Created by Summerkirakira on 21/12/2023.
//

import Foundation

func showErrorMessage(mainPageViewModel: MainPageViewModel, errorTitle: String, errorSubtitle: String) {
    mainPageViewModel.errorMessageTitle = errorTitle
    mainPageViewModel.errorMessageSubTitle = errorSubtitle
    mainPageViewModel.isShowErrorMessage = true
}

func showCompleteMessage(mainPageViewModel: MainPageViewModel, completeTitle: String, completeSubtitle: String? = nil) {
    mainPageViewModel.completeMessageTitle = completeTitle
    mainPageViewModel.completeMessageSubTitle = completeSubtitle
    mainPageViewModel.isShowCompleteMessage = true
}
