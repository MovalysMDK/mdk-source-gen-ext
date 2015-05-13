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

	<!-- This xsl manages configuration of the binding of the cell properties, 
		configuration declared in the section plist -->

	<!-- Conditions: * Cell type : MFCell1ComponentHorizontal * Form type : 
		form, fixedlist -->
	<xsl:template match="subView" mode="common-group-header">
		
					<key>@description</key>
			<string>
				<xsl:if test="../../@isNoTable='false'">Ce groupe décrit une cellule représentant le composant associé à l'attribut UML <xsl:value-of select="binding"/>.</xsl:if>
				<xsl:if test="../../@isNoTable='true'">Ce groupe le composant associé à l'attribut UML <xsl:value-of select="binding"/>.</xsl:if>
			</string>
			<xsl:if test="@visibleLabel = 'true'">
				<key>@info</key>
				<string>Le groupe décrit également le label associé à ce composant.</string>
			</xsl:if>
			
			<key>name</key>
			<string>group-<xsl:value-of select="@id"/></string>
			
			<key>visible</key>
			<string>YES</string>

			<key>noLabel</key>
			<xsl:if test="@visibleLabel = 'true'"><string>NO</string></xsl:if>
			<xsl:if test="@visibleLabel = 'false'"><string>YES</string></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="subView" mode="common-label-generation">
		
		<xsl:if test="@visibleLabel='true'">
		<dict>
			<key>@description</key>
			<string>Label associé au composant correspondant à l'attribut UML <xsl:value-of select="binding"/></string>
			
			<key>name</key>
			<string><xsl:value-of select="@labelView"/></string>
			
			<key>visible</key> 
			<xsl:if test="@visibleLabel = 'true'"><string>YES</string></xsl:if>
			<xsl:if test="@visibleLabel = 'false'"><string>NO</string></xsl:if>
			
			<xsl:if test="@mandatory">
				<key>mandatory</key>
				<xsl:if test="@mandatory = 'true'"><string>YES</string></xsl:if>
				<xsl:if test="@mandatory = 'false'"><string>NO</string></xsl:if>
			</xsl:if>
			
			<key>i18nKey</key>
			<string><xsl:value-of select="@labelView"/></string>
			
			<key>typeName</key>
			<string>MFLabel</string>
			
			<xsl:apply-templates select="." mode="cellPropertyLabelBinding-for-plist"/>
		</dict>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="subView" mode="common-component-generation">
		<xsl:param name="type" />
	
			<key>@description</key>
			<string>Composant de type <xsl:value-of select="$type"/> correspondant à l'attribut UML '<xsl:value-of select="binding"/>'</string>
			
			<key>name</key>
			<string><xsl:value-of select="@id"/></string>
			
			<key>visible</key>
			<string>YES</string>
			<xsl:if test="@readOnly">
				<key>editable</key>
				<xsl:if test="@readOnly = 'true'"><string>NO</string></xsl:if>
				<xsl:if test="@readOnly = 'false'"><string>YES</string></xsl:if>
			</xsl:if>
			
			<xsl:if test="@mandatory">
				<key>mandatory</key>
				<xsl:if test="@mandatory = 'true'"><string>YES</string></xsl:if>
				<xsl:if test="@mandatory = 'false'"><string>NO</string></xsl:if>
			</xsl:if>
			
			<xsl:if test="binding">
				<key>bindingKey</key>
				<string><xsl:value-of select="binding"/></string>
			</xsl:if>
		
			<key>typeName</key>
			<string><xsl:value-of select="$type"></xsl:value-of></string>
			
			<xsl:apply-templates select="." mode="cellPropertyValueBinding-for-plist"/>
		
			<key>#converter</key>
			<dict><key>@description</key><string>Spécifier ici les paramètres du converter</string></dict>
			
	</xsl:template>
	
</xsl:stylesheet>