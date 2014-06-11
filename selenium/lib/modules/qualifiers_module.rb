# -*- encoding : utf-8 -*-
# Wikidata UI tests
#
# Author:: Tobias Gritschacher (tobias.gritschacher@wikimedia.de)
# License:: GNU GPL v2+
#
# module for qualifiers page object

module QualifierPage
  include PageObject
  # qualifiers UI elements
  div(:qualifiersContainer, :class => "wb-claim-qualifiers")
  link(:addQualifier,			:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]//span[contains(@class, 'wb-addtoolbar')]//a[not(contains(@class, 'wikibase-toolbarbutton-disabled'))][text()='add qualifier']")
  link(:addQualifierDisabled,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]//span[contains(@class, 'wb-addtoolbar')]//a[contains(@class, 'wikibase-toolbarbutton-disabled')][text()='add qualifier']")
  link(:removeQualifierLine1,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][1]//span[contains(@class, 'wb-removetoolbar')]//a[not(contains(@class, 'wikibase-toolbarbutton-disabled'))][text()='remove']")
  link(:removeQualifierLine2,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][2]//span[contains(@class, 'wb-removetoolbar')]//a[not(contains(@class, 'wikibase-toolbarbutton-disabled'))][text()='remove']")
  text_area(:qualifierValueInput1, :xpath => "//div[contains(@class, 'wb-claim-qualifiers')]//textarea[contains(@class, 'valueview-input')]", :index => 0)
  text_area(:qualifierValueInput2, :xpath => "//div[contains(@class, 'wb-claim-qualifiers')]//textarea[contains(@class, 'valueview-input')]", :index => 1)

  div(:qualifierProperty1,		:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][1]//div[contains(@class, 'wb-snak-property-container')]/div")
  div(:qualifierProperty2,		:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][2]//div[contains(@class, 'wb-snak-property-container')]/div")
  link(:qualifierPropertyLink1,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][1]//div[contains(@class, 'wb-snak-property-container')]//a")
  link(:qualifierPropertyLink2,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][2]//div[contains(@class, 'wb-snak-property-container')]//a")
  link(:qualifierValueLink1,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][1]//div[contains(@class, 'wb-snak-value')]//a")
  link(:qualifierValueLink2,	:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][2]//div[contains(@class, 'wb-snak-value')]//a")
  div(:qualifierValue1,			:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][1]//div[contains(@class, 'wb-snak-value')]/div/div")
  div(:qualifierValue2,			:xpath => "//div[contains(@class, 'wb-claim-qualifiers')]/div/div[contains(@class, 'wb-snaklistview')][2]//div[contains(@class, 'wb-snak-value')]/div/div")

  def wait_for_qualifier_value_box
    wait_until do
      self.qualifierValueInput1?
    end
  end

  def add_qualifier_to_first_claim(property, value)
    editFirstStatement
    addQualifier
    self.entitySelectorInput = property
    ajax_wait
    wait_for_entity_selector_list
    wait_for_qualifier_value_box
    self.qualifierValueInput1 = value
    ajax_wait
    saveStatement
    ajax_wait
    wait_for_statement_request_finished
  end

end
