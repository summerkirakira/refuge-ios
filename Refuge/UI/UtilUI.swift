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
