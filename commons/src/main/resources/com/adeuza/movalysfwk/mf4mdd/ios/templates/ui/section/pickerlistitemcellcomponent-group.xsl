<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="ui/section/common-group.xsl"/>
	

	<xsl:template match="subView[customClass='MFPickerList']">
		<dict>
		
		<xsl:apply-templates select="." mode="common-group-header"/>
		
			<key>configurationName</key>
			<string>configuration<xsl:value-of select="./options/entry[@key = 'cell-selected-item-name']"/></string>
			<xsl:comment>  used to define the height of this cell => /resources/plist/configuration/conf-[screenName]Cell.plist	  </xsl:comment>

			<key>typeName</key>
			<string><xsl:value-of select="customClass"/>Cell</string>

			<xsl:call-template name="pickerListFields"/>
		</dict>
	</xsl:template>
	
	<xsl:template match="subView[customClass='MFPickerList']" mode="fieldForListItem">
		<xsl:call-template name="pickerListFields"/>
	</xsl:template>
	
	<xsl:template name="pickerListFields">
		<key>fields</key>
		<array>
			<xsl:apply-templates select="." mode="common-label-generation"/>
		
		<dict>
			<xsl:apply-templates select="." mode="common-component-generation">
			<xsl:with-param name="type">MFPickerList</xsl:with-param>
			</xsl:apply-templates>
		
			
				<key>parameters</key>
				<dict>
					<key>search</key>
					<xsl:choose>
						<xsl:when test="options/entry[@key='search'] = 'true'">
							<true/>
						</xsl:when>
						<xsl:otherwise>
							<false/>
						</xsl:otherwise>
					</xsl:choose>
					<key>pickerValuesKey</key>
					<string><xsl:value-of select="customParameterName"/></string>
					<key>selectedViewFormDescriptorName</key>
					<string><xsl:value-of select="./options/entry[@key = 'cell-selected-item-name']"/></string>
					<key>lstItemViewFormDescriptorName</key>
					<string><xsl:value-of select="linkedType"/></string>
				</dict>
			</dict>
		</array> 
	</xsl:template>
	
<xsl:template match="*" mode="cellPropertyLabelBinding-for-plist" priority="-1000">
	<xsl:comment>GENERATION ERROR in ...-group.xsl: missing include of "ui/section/cell-property-binding.xsl" (customClass=<xsl:value-of select="customClass"/>)</xsl:comment>
</xsl:template>
</xsl:stylesheet>
