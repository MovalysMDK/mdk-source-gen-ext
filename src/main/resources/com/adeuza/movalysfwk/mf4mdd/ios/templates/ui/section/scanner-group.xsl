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
	

	<xsl:template match="subView[customClass='MFBarCodeScanTextField']">
		<xsl:comment>template match="subView[customClass='MFBarCodeScanTextField']"</xsl:comment>
	<dict>
		
		<xsl:apply-templates select="." mode="common-group-header"/>

		<xsl:if test="../../@isNoTable='false'">
			<key>@GeneratedCellIdentifier</key>
			<string>MFBarCodeScanTextFieldCell<xsl:if test="@visibleLabel = 'false'">-noLabel</xsl:if></string>
		</xsl:if>
		
		
		<key>typeName</key>
		<string>MFBarCodeScanTextFieldCell</string>


		<key>configurationName</key>
		<string>mfscannercell</string>
		<xsl:comment>used to define the height of this cell => /resources/plist/configuration/conf-[configurationName].plist </xsl:comment>

		<key>fields</key>
		<array>
			<xsl:call-template name="scannerFields"/>
		</array>
	</dict>
	</xsl:template>
	
	<xsl:template match="subView[customClass='MFBarCodeScanTextField']" mode="fieldForListItem">
				<xsl:comment>template match="subView[customClass='MFBarCodeScanTextField']" mode="fieldForListItem"</xsl:comment>
		
		<xsl:call-template name="scannerFields"/>
	</xsl:template>
	
	<xsl:template name="scannerFields">
		<xsl:comment>template name="scannerFields"</xsl:comment>
		<xsl:apply-templates select="." mode="common-label-generation"/>
				
		<dict>
			<xsl:apply-templates select="." mode="common-component-generation">
			<xsl:with-param name="type">MFBarCodeScanTextField</xsl:with-param>
			</xsl:apply-templates>
		
			
		
			<key>#parameters</key>
			<dict>
			</dict>
		</dict>	
	</xsl:template>
	
	<xsl:template match="*" mode="cellPropertyLabelBinding-for-plist" priority="-1000">
		<ERROR>GENERATION ERROR in ...-group.xsl: missing include of "ui/section/cell-property-binding.xsl" (customClass=<xsl:value-of select="customClass"/>)</ERROR>
	</xsl:template>
	
</xsl:stylesheet>
