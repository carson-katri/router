extension Array where Element == Any {
    func splat() -> Any {
        switch count {
        case 1:
            return (
                self[0]
            ) as Any
        case 2:
            return (
                self[0],
                self[1]
            ) as Any
        case 3:
            return (
                self[0],
                self[1],
                self[2]
            ) as Any
        case 4:
            return (
                self[0],
                self[1],
                self[2],
                self[3]
            ) as Any
        case 5:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4]
            ) as Any
        case 6:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4],
                self[5]
            ) as Any
        case 7:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4],
                self[5],
                self[6]
            ) as Any
        case 8:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4],
                self[5],
                self[6],
                self[7]
            ) as Any
        case 9:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4],
                self[5],
                self[6],
                self[7],
                self[8]
            ) as Any
        case 10:
            return (
                self[0],
                self[1],
                self[2],
                self[3],
                self[4],
                self[5],
                self[6],
                self[7],
                self[8],
                self[9]
            ) as Any
        default:
            fatalError("""
            Router only supports up to 10 associated values. \
            Please file a bug if more are needed.
            """)
        }
    }
}
