Feature: Unmatched request handling

  @story-2
  Rule: A request to a path service1 does not serve returns a structured 404 body

    @negative
    Scenario: Requesting a path service1 does not serve
      Given service1 is running
      When an API Consumer requests a path service1 does not serve
      Then service1 responds with a structured 404 error body
