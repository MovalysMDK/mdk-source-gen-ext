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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="xml"/>

<xsl:include href="ui/section/cell-property-binding.xsl"/>

<xsl:include href="ui/section/browseurltextfield-group.xsl"/>
<xsl:include href="ui/section/webview-group.xsl"/>
<xsl:include href="ui/section/callphonenumbertextfield-group.xsl"/>
<xsl:include href="ui/section/positioncell-group.xsl"/>
<xsl:include href="ui/section/signature-group.xsl"/>
<xsl:include href="ui/section/numberpicker-group.xsl"/>
<xsl:include href="ui/section/photothumbnailcell-group.xsl"/>
<xsl:include href="ui/section/regularexpressiontextfield-group.xsl"/>
<xsl:include href="ui/section/sendmailtextfield-group.xsl"/>
<xsl:include href="ui/section/integertextfield-group.xsl"/>
<xsl:include href="ui/section/doubletextfield-group.xsl"/>
<xsl:include href="ui/section/textfield-group.xsl"/>
<xsl:include href="ui/section/fixedlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/pickerlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/photofixedlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/simplepickerlist-group.xsl"/>
<xsl:include href="ui/section/datepicker-group.xsl"/>
<xsl:include href="ui/section/enumimage-group.xsl"/>

<!--
doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"
	doctype-public="-//Apple//DTD PLIST 1.0//EN" -->

<xsl:template match="controller"><plist version="1.0">
	<dict>
		<key>name</key>
		<string><xsl:value-of select="formName"/></string>
		<key>typeName</key>
		<string><xsl:value-of select="customClass/name"/></string>
		<key>sections</key>
		<array>
			<xsl:apply-templates select="sections/section"/>
		</array>
	</dict>
</plist>

</xsl:template>

<xsl:template match="controller[@controllerType='COMBOVIEW']"><plist version="1.0">
	<dict>
		<key>typeName</key>
		<string><xsl:value-of select="itemCellClassName"/></string>
		<key>sections</key>
		<array>
			<dict>
				<key>typeName</key>
				<string><xsl:value-of select="itemCellClassName"/></string>
				<key>name</key>
				<string><xsl:value-of select="itemCellClassName"/></string>
				<key>visible</key>
				<string>YES</string>
				<key>groups</key>
				<array>
					<dict>
						<key>typeName</key>
						<string><xsl:value-of select="itemCellClassName"/></string>
						<key>visible</key>
						<string>YES</string>
						<key>name</key>
						<string>g<xsl:value-of select="itemCellClassName"/></string>
						<key>configurationName</key>
						<string><xsl:text>configuration</xsl:text><xsl:value-of select="itemCellClassName"/></string>
						<key>fields</key>
						<array>
							<xsl:apply-templates select="sections/section/subViews/subView[@xsi:type='miosEditableView' and (localization='DEFAULT' or localization='LIST')]" mode="fieldForListItem"/>
						</array>
					</dict>
				</array>
			</dict>
		</array>
	</dict>
</plist>

</xsl:template>


<xsl:template match="section">
	<dict>
		<key>_include</key>
		<string>section-<xsl:value-of select="@name"/></string>
	</dict>
</xsl:template>



<xsl:template match="subView[customClass='UILabel' or customClass='MFLabel']" >
	<xsl:comment>UILabel or MFLabel generation skipped in section-listitem-plist.xsl</xsl:comment>
</xsl:template>

<xsl:template match="subView" mode="fieldForListItem" priority="-1000">
	<ERROR>GENERATION ERROR in form-combo-item-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="fieldForListItem"</ERROR>
</xsl:template>

<xsl:template match="subView" priority="-1000">
	<ERROR>GENERATION ERROR in form-combo-item-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/></ERROR>
</xsl:template>

<xsl:template match="subView" mode="gen-table-cell"  priority="-1000">
	<ERROR>GENERATION ERROR in form-combo-item-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="gen-table-cell"</ERROR>
</xsl:template>
</xsl:stylesheet>
