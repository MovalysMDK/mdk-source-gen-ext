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
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="ui/section/common-group.xsl"/>


	<xsl:template match="subView[(customClass='MFCellPhotoFixedList' or cellType='MFCellPhotoFixedList')]">
		<dict>
		
		<xsl:apply-templates select="." mode="common-group-header"/>
		
			<key>typeName</key>
			<string><xsl:value-of select="linkedType"/></string>

			<key>configurationName</key>
			<string>configuration<xsl:value-of select="linkedType"/></string>
			<xsl:comment>  used to define the height of this cell => /resources/plist/configuration/conf-[screenName]Cell.plist	  </xsl:comment>

			<xsl:call-template name="photofixedListFields"/>
		</dict>
	</xsl:template>
	
	<xsl:template match="subView[(customClass='MFCellPhotoFixedList' or cellType='MFCellPhotoFixedList')]" mode="fieldForListItem">
		<xsl:call-template name="photofixedListFields"/>
	</xsl:template>
	
	<xsl:template name="photofixedListFields">
		<key>fields</key>
		<array>
			<dict>
				<xsl:apply-templates select="." mode="common-component-generation">
				<xsl:with-param name="type">MFFixedList</xsl:with-param>
				</xsl:apply-templates>
				
				<key>addItemListener</key>
				<string>addItemMethod</string>
				<key>deleteItemListener</key>
				<string>deleteItemMethod</string>
				<key>editItemListener</key>
				<string>editItemMethod</string>
				<key>visible</key>
				<string>YES</string>ct>
				<key>parameters</key>
				<dict>
					<key>title</key>
					<string><xsl:value-of select="@labelView"/></string>
					<key>canEditItem</key>
					<true/>
					<key>canAddItem</key>
					<true/>
					<key>canDeleteItem</key>
					<true/>
					<key>editMode</key>
					<integer>0</integer>
					<key>rowHeight</key>
					<integer><xsl:value-of select="./@height"/></integer>
					<key>formDescriptorName</key>
					<string><xsl:value-of select="./linkedType"/></string>
					<key>dataDelegateName</key>
					<string><xsl:value-of select="./options/entry[@key = 'dataDelegateName']"/></string>
					<key>isPhotoFixedList</key>
					<xsl:choose>
						<xsl:when test="./linkedType = 'PhotoFixedListItemCell'">
							<true/>
						</xsl:when>
						<xsl:otherwise>
							<false/>
						</xsl:otherwise>
					</xsl:choose>
				</dict>
				<xsl:apply-templates select="." mode="cellPropertyValueBinding-for-plist"/>
			</dict>
		</array> 
	</xsl:template>

<xsl:template match="*" mode="cellPropertyLabelBinding-for-plist" priority="-1000">
	<ERROR>GENERATION ERROR in ...-group.xsl: missing include of "ui/section/cell-property-binding.xsl" (customClass=<xsl:value-of select="customClass"/>)</ERROR>
</xsl:template>

</xsl:stylesheet>
