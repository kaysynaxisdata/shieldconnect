import Swinject

protocol AppAssemblyFactoryProtocol {
    func makeAppAssemblies() -> [Assembly]
}

final class AppAssemblyFactory: AppAssemblyFactoryProtocol {
    func makeAppAssemblies() -> [Assembly] {
        let assemblies: [Assembly] = [
            ServicesAssembly(),
            CoordinatorsAssembly()
        ]
        return assemblies
    }
}
