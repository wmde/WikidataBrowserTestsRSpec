# -*- encoding : utf-8 -*-
# Wikidata UI tests
#
# Author:: Tobias Gritschacher (tobias.gritschacher@wikimedia.de)
# License:: GNU GPL v2+
#
# page object for entity page

require 'ruby_selenium'

class EntityPage < RubySelenium
  include PageObject
  include SitelinkPage
  include AliasPage
  include StatementPage
  include InputExtenderPage
  include TimePage
  include CoordinatePage
  include ULSPage

  @@property_url = ""
  @@property_id = ""
  @@item_url = ""
  @@item_id = ""

  # ***** ACCESSORS *****
  # label UI
  h1(:mwFirstHeading, :id => "firstHeading")
  h1(:firstHeading, :xpath => "//h1[contains(@class, 'wb-firstHeading')]")
  h1(:uiPropertyEdittool, :class => "wb-ui-propertyedittool")
  span(:entityLabelSpan, :xpath => "//h1[contains(@class, 'wb-firstHeading')]/span/span")
  text_field(:labelInputField, :xpath => "//h1[contains(@class, 'wb-firstHeading')]/span/span/input")
  link(:editLabelLink,				:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(1)")
  link(:editLabelLinkDisabled,		:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(1)")
  link(:saveLabelLink,				:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(1)")
  link(:saveLabelLinkDisabled,		:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(1)")
  link(:cancelLabelLink,			:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(2)")
  link(:cancelLabelLinkDisabled,	:css => "h1.wb-firstHeading .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(2)")

  # description UI
  span(:entityDescriptionSpan, :xpath => "//div[contains(@class, 'wb-ui-descriptionedittool')]/span[contains(@class, 'wb-property-container-value')]/span")
  text_field(:descriptionInputField, :xpath => "//div[contains(@class, 'wb-ui-descriptionedittool')]/span[contains(@class, 'wb-property-container-value')]/span/input")
  link(:editDescriptionLink,			:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(1)")
  link(:editDescriptionLinkDisabled,	:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(1)")
  link(:saveDescriptionLink,			:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(1)")
  link(:saveDescriptionLinkDisabled,	:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(1)")
  link(:cancelDescriptionLink,			:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton:not(.wikibase-toolbarbutton-disabled):nth-child(2)")
  link(:cancelDescriptionLinkDisabled,	:css => "div.wb-ui-descriptionedittool .wikibase-toolbar > a.wikibase-toolbarbutton-disabled:nth-child(2)")

  span(:apiCallWaitingMessage, :class => "wb-ui-propertyedittool-editablevalue-waitmsg")

  # edit-tab
  list_item(:editTab, :id => "ca-edit")

  # spinner
  div(:entitySpinner, :xpath => "//div[contains(@class, 'wb-entity-spinner')]")

  # tooltips & error tooltips
  div(:wbTooltip, :class => "tipsy-inner")
  div(:wbErrorDiv, :class => "wikibase-wbtooltip-error-top-message")
  div(:wbErrorDetailsDiv, :class => "wikibase-wbtooltip-error-details")
  link(:wbErrorDetailsLink, :class => "wikibase-wbtooltip-error-details-link")

  # mw notifications
  div(:mwNotificationContent, :xpath => "//div[@id='mw-notification-area']/div/div[contains(@class, 'mw-notification-content')]")

  # ***** METHODS *****
  def wait_for_api_callback
    #TODO: workaround for weird error randomly claiming that apiCallWaitingMessage-element is not attached to the DOM anymore
    sleep 1
    return
    wait_until do
      apiCallWaitingMessage? == false
    end
  end

  def wait_for_entity_to_load
    sleep 1
    wait_until do
      entitySpinner? == false
    end
  end

  def wait_for_editLabelLink
    wait_until do
      editLabelLink?
    end
  end

  def change_label(label)
    if editLabelLink?
      editLabelLink
    end
    self.labelInputField= label
    saveLabelLink
    ajax_wait
    wait_for_api_callback
  end

  def change_description(description)
    if editDescriptionLink?
      editDescriptionLink
    end
    self.descriptionInputField= description
    saveDescriptionLink
    ajax_wait
    wait_for_api_callback
  end

  def wait_for_mw_notification_shown
    wait_until do
      mwNotificationContent? == true
    end
  end

  def wait_for_error_details
    wait_until do
      sleep 0.5
      wbErrorDetailsDiv? == true
    end
  end

  def set_copyright_ack_cookie
    cookie = "$.cookie( 'wikibase.acknowledgedentitycopyright.en', 'By clicking \"save\", you agree to the terms of use, and you irrevocably agree to release your contribution under the [ ].', { 'expires': null, 'path': '/' } );"
    @browser.execute_script(cookie)
  end
end
