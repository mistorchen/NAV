import Foundation

struct dK{

    struct category{
        struct plyo {
            static let lower = "/database/plyo/lower"
            static let upper = "/database/plyo/upper"
            static let mixed = "/database/plyo/mixed"
        }
        struct upper {
            static let push = "/database/upper/push"
            static let pull = "/database/upper/pull"
        }
        struct lower {
            static let bilateral = "/database/lower/bilateral"
            static let unilateral = "/database/upper/unilateral"
        }
        struct core {
            static let dynamic = "/database/core/dynamic"
            static let isometric = "/database/core/isometric"
        }
        struct arms {
            static let bicep = "/database/arms/biceps"
            static let tricep = "/database/arms/triceps"
            static let shoulders = "/database/arms/shoulders"
        }
    }
    
}
