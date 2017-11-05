=begin

  SDMS Script
  -----------
  require 'DSKMFRuleStandardRedirects.rb'
  smwck = SDMS::SemanticMediaWiki.new(@oProfiles, "smwck_restored", @hOptions)
  rule = SDMS::Rules::DSStandardRedirects.new(@hOptions)
  rule.enforce_on_SYSTEM(smwck)

=end

module SDMS
  module Rules
    class DSStandardRedirects < Rule

      def initialize hOptions
        super
      end

      def enforce_on_SYSTEM oSystem
        # This is the concrete rule content
        hRedirects = {}
        oSystem.aTopics.each do |oTopic|
          hRedirects[oTopic.sName] = [
            oTopic.sTitle
          ]
        end
        hRedirects.each do |sTargetPageName, hSourcePageNames|
          hSourcePageNames.each do |sSourcePageName|
            if(oSystem.has_redirect_from_PAGENAME_to_PAGENAME?(sSourcePageName, sTargetPageName))
              SDMS.logMessage("EXISTS: Redirect from #{sSourcePageName} to #{sTargetPageName}")
            else
              oSystem.create_redirect_from_PAGENAME_to_PAGENAME(sSourcePageName, sTargetPageName)
            end
          end
        end
      end

    end
  end
end
