import Foundation

protocol Coordinator: AnyObject {
    var container: DIContainer { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
