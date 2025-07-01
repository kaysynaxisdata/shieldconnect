//
//  AppDelegate.swift
//  shield-connect
//
//  Created by Александр on 29.03.2025.
//

import UIKit
import Swinject
import Adapty

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var assembler: Assembler!
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupSDK()
        setupAssembler()
        setupDependencies()
        
        return true
    }
    
    func setupAssembler() {
        let container = Container()

        let factory = AppAssemblyFactory()
        assembler = Assembler(
            factory.makeAppAssemblies(),
            container: container
        )
        
        container.register(Assembler.self) { _ in
            self.assembler
        }.inObjectScope(.container)
    }
    
    func setupDependencies() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        // Setup navigation
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController

        // Create and start coordinator
        appCoordinator = assembler.resolver.resolve(AppCoordinator.self, argument: navigationController)
        appCoordinator?.start()

        window?.makeKeyAndVisible()
    }
    
    func setupSDK() {
        Adapty.activate("public_live_ZWg3dzS1.kmqWTrGRZxmJuBlJ0yNY")
    }

}

