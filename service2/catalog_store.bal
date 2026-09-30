// Seed data and in-memory mode state for the scored catalog.

public type CatalogMode "full"|"empty";

final readonly & Record[] seedRecords = [
    {id: 1, name: "alpha-record", score: 41},
    {id: 2, name: "beta-record", score: 17},
    {id: 3, name: "gamma-record", score: 63},
    {id: 4, name: "delta-record", score: 28},
    {id: 5, name: "epsilon-record", score: 55},
    {id: 6, name: "zeta-record", score: 12},
    {id: 7, name: "eta-record", score: 39},
    {id: 8, name: "theta-record", score: 74},
    {id: 9, name: "iota-record", score: 21},
    {id: 10, name: "kappa-record", score: 8}
];

CatalogMode currentMode = "full";

function getCurrentMode() returns CatalogMode {
    return currentMode;
}

function setCurrentMode(CatalogMode mode) {
    currentMode = mode;
}

function currentCatalog() returns Record[] {
    if currentMode == "empty" {
        return [];
    }
    return seedRecords;
}
