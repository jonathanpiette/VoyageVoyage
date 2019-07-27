//
//  Protocols.swift
//  VoyageVoyage
//
//  Created by Cr3AD on 27/05/2019.
//  Copyright © 2019 Cr3AD. All rights reserved.
//

import Foundation

// Location

public protocol DidUpdateLocation {
    func getWeatherDataAtLocation()
}

// Data

protocol WeatherData {
    func receiveWeatherData(_ data: WeatherJSON)
}

protocol ForcastData {
    func receiveForcastData(_ data: ForcastJSON)
}

protocol MoneyData {
    func receiveMoneyData(_ data: MoneyJSON)
}

protocol TranslationData {
    func receiveTranslationData(_ data: TranslationJSON)
}


// Error

public protocol ShowErrorMessage {
    func showAlertNoConnectionError(with title: String, and message: String)
    
}

// Segue

public protocol GetMoneyInChoosen {
    func updateMoneyInChoosen(data: String)
}

public protocol GetMoneyOutChoosen {
    func updateMoneyOutChoosen(data: String)
}

public protocol GetLangInChoosen {
    func updateLangInChoosen(data: String)
}

public protocol GetLangOutChoosen {
    func updateLangOutChoosen(data: String)
}

