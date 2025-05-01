import Swinject

public final class AppAssembler {
    public static var resolver: Resolver {
        return assembler.resolver
    }
    
    public static let assembler = Assembler(container: Container())

    private init() { }
    
    public static func apply(assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
    
    public static func apply(assembly: Assembly) {
        assembler.apply(assembly: assembly)
    }
}
