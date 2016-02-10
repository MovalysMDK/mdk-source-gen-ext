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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ex="http://exslt.org/dates-and-times"  extension-element-prefixes="ex">

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard/scenes/*scene/controller[@controllerType='NAVIGATION']
*****  
****************************************************** -->
<xsl:output method="xml"/>

<xsl:template match="controller[@controllerType='NAVIGATION']">
	
	<xsl:comment>
		#############################
		Controller type = '<xsl:value-of select="@controllerType"/>' - <xsl:value-of select="@type"/>
		Controller ID =  '<xsl:value-of select="@id"/>'
		View ID =  '<xsl:value-of select="@viewId"/>'
		Generation time = <xsl:value-of  select="ex:date-time()"/>
		#############################		
	</xsl:comment>
	
		<navigationController definesPresentationContext="YES" sceneMemberID="viewController">
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<navigationBar key="navigationBar" contentMode="scaleToFill">
			<xsl:attribute name="id"><xsl:value-of select="@navigationBarId"/></xsl:attribute>	
			<autoresizingMask key="autoresizingMask"/>
		</navigationBar>
		<connections>
			<segue kind="relationship" relationship="rootViewController" >
				<xsl:attribute name="id"><xsl:value-of select="@rootControllerSegueId"/></xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@rootController"/></xsl:attribute>
			</segue>
		</connections>
	</navigationController>
</xsl:template>

</xsl:stylesheet>