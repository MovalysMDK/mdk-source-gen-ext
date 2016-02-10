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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"/>

<xsl:include href="ui/section/cell-property-binding.xsl"/>

<xsl:include href="ui/section/browseurltextfield-group.xsl"/>
<xsl:include href="ui/section/callphonenumbertextfield-group.xsl"/>
<xsl:include href="ui/section/datepicker-group.xsl"/>
<xsl:include href="ui/section/doubletextfield-group.xsl"/>
<xsl:include href="ui/section/fixedlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/integertextfield-group.xsl"/>
<xsl:include href="ui/section/numberpicker-group.xsl"/>
<xsl:include href="ui/section/photofixedlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/photothumbnailcell-group.xsl"/>
<xsl:include href="ui/section/positioncell-group.xsl"/>
<xsl:include href="ui/section/regularexpressiontextfield-group.xsl"/>
<xsl:include href="ui/section/sendmailtextfield-group.xsl"/>
<xsl:include href="ui/section/pickerlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/signature-group.xsl"/>
<xsl:include href="ui/section/simplepickerlist-group.xsl"/>
<xsl:include href="ui/section/enumimage-group.xsl"/>
<xsl:include href="ui/section/textfield-group.xsl"/>
<xsl:include href="ui/section/textview-group.xsl"/>
<xsl:include href="ui/section/webview-group.xsl"/>
<xsl:include href="ui/section/slider-group.xsl"/>
<xsl:include href="ui/section/switch-group.xsl"/>
<xsl:include href="ui/section/scanner-group.xsl"/>

<xsl:template match="section"><plist version="1.0">
	<dict>
		<key>@description</key>
		<string>Ce formulaire PLIST décrit le panel (ou section) correspondant à la classe UML <xsl:value-of select="@name"/></string>
		<xsl:if test="@isNoTable = 'false'">
			<key>@info</key>
			<string><xsl:text>Cette section est représentée sous forme d'une UITableView.</xsl:text></string>
		</xsl:if>
		<xsl:if test="@isNoTable = 'true'">
			<key>@info</key>
			<string><xsl:text>Cette section est représentée dans la vue du ViewController (Mm_iOS_noTableView)</xsl:text></string>
		</xsl:if>
		<key>isInRootView</key>
		<xsl:if test="@isNoTable = 'true'"><true /></xsl:if>
		<xsl:if test="@isNoTable = 'false'"><false /></xsl:if>		
		<key>name</key>
		<string><xsl:value-of select="@name"/></string>
		<key>titled</key>
		<xsl:if test="@titled = 'true'"><true /></xsl:if>
		<xsl:if test="@titled = 'false'"><false /></xsl:if>
		<key>groups</key>
		<array>
			<xsl:apply-templates select="subViews/subView[localization = 'DEFAULT' or localization = 'DETAIL']"/>
		</array>
	</dict>
</plist>
</xsl:template>

<xsl:template match="subView[customClass='UILabel' or customClass='MFLabel']" >
	<xsl:comment>UILabel or MFLabel generation skipped in section-plist.xsl</xsl:comment>
</xsl:template>

<xsl:template match="subView" mode="fieldForListItem" priority="-1000">
	<ERROR>GENERATION ERROR in section-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="fieldForListItem"</ERROR>
</xsl:template>

<xsl:template match="subView" priority="-1000">
	<ERROR>GENERATION ERROR in section-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/></ERROR>
</xsl:template>

<xsl:template match="subView" mode="gen-table-cell"  priority="-1000">
	<ERROR>GENERATION ERROR in section-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="gen-table-cell"</ERROR>
</xsl:template>

</xsl:stylesheet>
