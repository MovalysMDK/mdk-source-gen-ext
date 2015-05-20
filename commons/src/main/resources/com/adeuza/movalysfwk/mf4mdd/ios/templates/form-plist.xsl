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
<xsl:include href="ui/section/photofixedlistitemcellcomponent-group.xsl"/>
<xsl:include href="ui/section/simplepickerlist-group.xsl"/>
<xsl:include href="ui/section/datepicker-group.xsl"/>
<xsl:include href="ui/section/slider-group.xsl"/>
<xsl:include href="ui/section/switch-group.xsl"/>
<xsl:include href="ui/section/enumimage-group.xsl"/>

<!--
doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"
	doctype-public="-//Apple//DTD PLIST 1.0//EN" 
	-->

<xsl:template match="controller"><plist version="1.0">
	<dict>
		<key>@description</key>
		<xsl:if test="customClass/superClassName = 'MFDetailFormViewController'">
			<string>Ce formulaire PLIST décrit l'écran <xsl:value-of select="customClass/name"/>. Il s'agit d'un écran de détail d'un item de MFFixedList.</string>
		</xsl:if>
		<xsl:if test="customClass/superClassName = 'MFFormViewController'">
			<string>Ce formulaire PLIST décrit l'écran <xsl:value-of select="customClass/name"/> et correspond à la classe UML <xsl:value-of select="formName"/>.</string>
		</xsl:if>
		<xsl:if test="customClass/superClassName = 'MFListViewController'">
			<string>Ce formulaire PLIST décrit l'écran <xsl:value-of select="customClass/name"/> et présente une liste d'items correspondand à la classe UML <xsl:value-of select="formName"/>.</string>
		</xsl:if>
		<xsl:if test="customClass/superClassName = 'MFSearchViewController'">
			<string>Ce formulaire PLIST décrit l'écran <xsl:value-of select="customClass/name"/> et correspond à la classe UML <xsl:value-of select="formName"/>.</string>
		</xsl:if>
		<xsl:if test="isInContainerViewController = 'true'">
			<key>@info</key>
			<string>
			<xsl:choose>
				<xsl:when test="workspaceRole = 'WORKSPACE_MASTER'">
					<xsl:text>Cet écran est l'écran maître d'un workspace.</xsl:text>
				</xsl:when>
				<xsl:when test="workspaceRole = 'WORKSPACE_DETAIL'">
					<xsl:text>Cet écran est une colonne-détail d'un workspace.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Cet écran est contenu dans un controller multi-sections.</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			</string>
		</xsl:if>
		<key>name</key>
		<string><xsl:value-of select="formName"/></string>
		<key>sections</key>
		<array>
			<xsl:apply-templates select="sections/section"/>
		</array>
	</dict>
</plist>

</xsl:template>

<xsl:template match="controller[@controllerType='FIXEDLISTVIEW']"><plist version="1.0">
	<dict>
		<key>typeName</key>
		<string><xsl:value-of select="cellClassName"/></string>
		<key>sections</key>
		<array>
			<dict>
				<key>typeName</key>
				<string><xsl:value-of select="cellClassName"/></string>
				<key>name</key>
				<string><xsl:value-of select="cellClassName"/></string>
				<key>visible</key>
				<string>YES</string>
				<key>groups</key>
				<array>
					<dict>
						<key>typeName</key>
						<string><xsl:value-of select="cellClassName"/></string>
						<key>visible</key>
						<string>YES</string>
						<key>name</key>
						<string>g<xsl:value-of select="cellClassName"/></string>
						<key>configurationName</key>
						<string></string>
						<key>fields</key>
						<array>
							<xsl:apply-templates select="sections/section/subViews/subView[@xsi:type='miosEditableView' and (localization='DEFAULT' or localization='LIST')]"
								mode="fieldForListItem"/>
						</array>
					</dict>
				</array>
			</dict>
		</array>
	</dict>
</plist>

</xsl:template>

<xsl:template match="controller[@controllerType='LISTVIEW2D']"><plist version="1.0">
	<dict>
		<key>@description</key>
		<string>Ce formulaire PLIST décrit une partie de l'écran <xsl:value-of select="customClass/name"/>. Il s'agit d'un écran de type Liste 2D correspondant à la classe UML <xsl:value-of select="formName"/></string>
		<key>@info</key>
		<xsl:if test="sections/section[1]/sectionType = 'LISTSECTION'">
			<string><xsl:text>Ce formulaire PLIST décrit les sections (niveau 1) d'une liste 2D.</xsl:text></string>
		</xsl:if>
		<xsl:if test="sections/section[1]/sectionType = 'LISTCELL'">
			<string><xsl:text>Ce formulaire PLIST décrit les items (niveau 2) d'une liste 2D.</xsl:text></string>
		</xsl:if>
		
		<key>typeName</key>
		<string><xsl:value-of select="cellClassName"/></string>
		<key>sections</key>
		<array>
			<xsl:apply-templates select="sections/section"/>
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
	<xsl:comment>UILabel or MFLabel generation skipped in form-plist.xsl</xsl:comment>
</xsl:template>

<xsl:template match="subView" mode="fieldForListItem" priority="-1000">
</xsl:template>

<xsl:template match="subView" priority="-1000">
</xsl:template>

<xsl:template match="subView" mode="gen-table-cell"  priority="-1000">
</xsl:template>


</xsl:stylesheet>
