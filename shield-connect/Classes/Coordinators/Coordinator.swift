import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func clearChildCoordinators()
    func finish()

}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.forEach { $0.removeAllChildCoordinators() }
        childCoordinators = []
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func getChildCoordinators<T: Coordinator>(ofType type: T.Type) -> [T] {
        var coordinatorsOfType: [T] = []

        for child in childCoordinators {
            if let coordinatorOfType = child as? T {
                coordinatorsOfType.append(coordinatorOfType)
            }
            coordinatorsOfType += child.getChildCoordinators(ofType: type)
        }

        return coordinatorsOfType
    }
    
    func clearChildCoordinators() {
        for child in childCoordinators {
            child.clearChildCoordinators()
        }
        childCoordinators = []
        finish()
    }

}
