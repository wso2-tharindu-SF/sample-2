Feature: Catalog mode control

  @story-3
  Rule: An Internal Operator can switch service2 into empty mode

    Scenario: Switching the catalog to empty mode
      Given service2 is serving its full catalog
      When an Internal Operator switches service2 into empty mode
      Then service2 serves a catalog with no records

  @story-4
  Rule: An Internal Operator can switch service2 back into full mode

    Scenario: Switching the catalog back to full mode
      Given service2 is serving an empty catalog
      When an Internal Operator switches service2 into full mode
      Then service2 serves the full catalog of 10 records
