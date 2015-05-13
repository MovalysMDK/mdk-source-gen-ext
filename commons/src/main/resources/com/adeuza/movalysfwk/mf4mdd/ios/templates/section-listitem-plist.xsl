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
<xsl:include href="ui/section/signature-group.xsl"/>
<xsl:include href="ui/section/simplepickerlist-group.xsl"/>
<xsl:include href="ui/section/textfield-group.xsl"/>
<xsl:include href="ui/section/pickerlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/textview-group.xsl"/>
<xsl:include href="ui/section/webview-group.xsl"/>
<xsl:include href="ui/section/slider-group.xsl"/>
<xsl:include href="ui/section/switch-group.xsl"/>
<xsl:include href="ui/section/enumimage-group.xsl"/>

<xsl:template match="controller[@controllerType='LISTVIEW' or @controllerType='FIXEDLISTVIEW'  or @controllerType='LISTVIEW2D']">
	<xsl:apply-templates select="sections/section"/>
</xsl:template>

<!-- Choix du bon typeName en fonction du type de la section -->
<xsl:template match="section"><plist version="1.0">
<xsl:variable name="typeName">
	<xsl:choose>
	  <xsl:when test="./sectionType = 'LISTHEADER'">
	  	<xsl:value-of select="../../headerFormName"/>
	  </xsl:when>
	  <xsl:when test="./sectionType = 'LISTSECTION'">
	  	<xsl:value-of select="../../sectionFormName"/>
	  </xsl:when>
	  <xsl:when test="./sectionType = 'LISTCELL'">
	  	<xsl:value-of select="../../cellClassName"/>
	  </xsl:when>
	  <xsl:otherwise>
	  	<xsl:value-of select="../../cellClassName"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:variable>
      

	<dict>
		<key>typeName</key>
		<string></string>
		<key>configurationName</key>
		<string></string>
		<key>name</key>
		<string><xsl:value-of select="@name"/></string>
		<key>visible</key>
		<string>YES</string>
		<key>groups</key>
		<array>
		 	<dict>
				<key>typeName</key>
				<string><xsl:value-of select="$typeName"/></string>
				<key>visible</key>
				<string>YES</string>
				<key>name</key>
				<string>group-<xsl:value-of select="$typeName"/></string>
				<key>configurationName</key>
				<string>configuration<xsl:value-of select="$typeName"/></string>
				<key>fields</key>
				<array>
					<xsl:apply-templates select="subViews/subView" mode="fieldForListItem"/>
				</array>
			</dict>
		</array>
	</dict>
</plist>
</xsl:template>

<xsl:template match="subView[customClass='UILabel' or customClass='MFLabel']" >
	<xsl:comment>UILabel or MFLabel generation skipped in section-listitem-plist.xsl</xsl:comment>
</xsl:template>

<xsl:template match="subView" mode="fieldForListItem" priority="-1000">
	<ERROR>GENERATION ERROR in section-listitem-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="fieldForListItem"</ERROR>
</xsl:template>

<xsl:template match="subView" priority="-1000">
	<ERROR>GENERATION ERROR in section-listitem-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/></ERROR>
</xsl:template>

<xsl:template match="subView" mode="gen-table-cell"  priority="-1000">
	<ERROR>GENERATION ERROR in section-listitem-plist.xsl: not handled when customClass=<xsl:value-of select="customClass"/> and cellType=<xsl:value-of select="cellType"/> and mode="gen-table-cell"</ERROR>
</xsl:template>

</xsl:stylesheet>
