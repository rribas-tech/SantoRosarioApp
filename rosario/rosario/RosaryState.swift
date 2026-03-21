import Observation

@Observable
final class RosaryState {
    let beads = Bead.makeRosary()
    var selectedBeadID: Int?

    func select(_ id: Int) {
        selectedBeadID = (selectedBeadID == id) ? nil : id
    }
}
