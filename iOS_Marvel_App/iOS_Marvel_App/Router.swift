//
//  Router.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 30/10/23.
//

import UIKit

protocol RouterProtocol {
    var navstack: UINavigationController { get }
}

final class Router: RouterProtocol {
    
    var navstack: UINavigationController
    
    init(navstack: UINavigationController) {
        self.navstack = navstack
    }
    
    func moveToMarvelListScreen() {
        let vm = MarvelListViewModel(baseUrl: ServiceHandler().getCharactersAPIURL())
        vm.serviceProvider = ServiceDataSource()
        let marvelListVC = MarvelListViewController()
        marvelListVC.viewModel = vm
        vm.view = marvelListVC
        navstack.pushViewController(marvelListVC, animated: true)
        setScreenAsRootViewController(vc: marvelListVC)
    }
    
    private func setScreenAsRootViewController(vc: UIViewController) {
        UIApplication.shared.delegate?.window??.rootViewController = vc
    }
}
