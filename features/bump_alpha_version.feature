Feature: Bumping the alpha version for a pivotal product
Given I want to increment the alpha version of a pivotal product
As a developer or a CI server
Then I need to be able to pass the relevant information into the command line

  Background: Running the command
    Given a file named "metadata_parts/binaries.yml" with:
    """
    ---
    name: example-product
    product_version: 1.2.3.4-alpha32
    metadata_version: '1.2'
    provides_product_versions:
      - name: example-product
        version: 1.2.3.4-alpha32
    stemcell:
      name: foo
      version: '1'
      file: a_stemcell.tgz
      md5: d41d8cd98f00b204e9800998ecf8427e
    releases:
    - file: cf-158.1-dev.tgz
      name: cf
      version: '158.1-dev'
      md5: d41d8cd98f00b204e9800998ecf8427e
    """

    When I run `bump-alpha-version --binaries-yaml='metadata_parts/binaries.yml'`

  Scenario: Exit status
    Then the exit status should be 0

  Scenario: Helpful output upon successful .pivotal and materials creation
    Then the output should match /incrementing version from 1.2.3.4-alpha32 to 1.2.3.4-alpha33/
#    And a file named "metadata_parts/binaries.yml" should exist
#    And a file named "example-product-1.1.0.0-rc123.pivotal.yml" should exist
#    And a file named "example-product-1.1.0.0-rc123.pivotal.md5" should exist
#
#  Scenario: Checking that the zip file contains the release
#    When I run `unzip -l example-product-1.1.0.0-rc123.pivotal`
#    Then the output should match /cf-158.1-dev.tgz/
#    And the output should match /a_stemcell.tgz/
#    And the output should match /example_migrations.yml/
#    And the output should match /example_metadata.yml/
