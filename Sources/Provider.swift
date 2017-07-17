import Vapor
import LeafProvider

public final class PaginatorProvider: Vapor.Provider {
    public static var repositoryName: String = "Paginator"

    public func boot(_ config: Config) throws {}

    public func boot(_ drop: Droplet) {
        guard let renderer = drop.view as? LeafRenderer else {
            print("warning: you are not using Leaf, cannot register Paginator extensions.")
            return
        }
        
        renderer.stem.register(PaginatorTag(useBootstrap4: useBootstrap4, paginationLabel: paginationLabel, visiblePages: visiblePages))
    }
    
    fileprivate let useBootstrap4: Bool
    fileprivate let paginationLabel: String?
    fileprivate let visiblePages: Int?
    
    public init(useBootstrap4: Bool = false, paginationLabel: String? = nil, visiblePages: Int?) {
        self.useBootstrap4 = useBootstrap4
        self.paginationLabel = paginationLabel
        self.visiblePages = visiblePages
    }
    
    /**
        Creates a Paginator provider from a `paginator.json` config file. Both the config file
        and the options are optional, and it will default to Bootstrap 3 with no Aria Label if
        none supplied
     
         The file may contain similar JSON:
         
         {
            "useBootstrap4": true,
            "paginatorLabel": "Blog Post Pages",
            "visiblePages": 8
         }
     */
    public init(config: Config) throws {
        
        var useBootstrap4Value = false
        var paginatorLabelValue: String? = nil
        var visiblePagesValue: Int? = nil

        
        
        if let paginatorConfig = config["paginator"]?.object {
            paginatorLabelValue = paginatorConfig["paginatorLabel"]?.string
            visiblePagesValue = paginatorConfig["visiblePages"]?.int
            if let bootstrap4 = paginatorConfig["useBootstrap4"]?.bool {
                useBootstrap4Value = bootstrap4
            }
        }
        
        useBootstrap4 = useBootstrap4Value
        paginationLabel = paginatorLabelValue
        visiblePages = visiblePagesValue
    }
    public func afterInit(_ drop: Droplet) {}
    public func beforeRun(_: Droplet) {}
}
