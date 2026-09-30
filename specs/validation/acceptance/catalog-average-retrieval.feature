Feature: Catalog average retrieval

  @story-1
  Rule: Service1 returns the average score of whatever catalog service2 is currently serving

    Scenario: Average of the full catalog
      Given service2 is serving its full catalog
      When an API Consumer requests the average score from service1
      Then service1 returns an average score of 35
