//
//  DIContainer.swift
//  YandexDiskRelease
//
//  Created by MacPro on 25.07.2022.
//

import Foundation

protocol DIContainerProtocol {
    
    func register<Service>(type: Service.Type, component: Any)
    
    func resolve<Service>(type: Service.Type) -> Service
}

final class DIContainer: DIContainerProtocol {
    
    static let shared = DIContainer()
    
    private init() {}
    
    var services: [String : Any] = [:]
    
    func register<Service>(type: Service.Type, component: Any) {
        services["\(type)"] = component
    }
    
    func resolve<Service>(type: Service.Type) -> Service {
        return services["\(type)"] as! Service
    }
}
