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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  extension-element-prefixes="xsi">

	

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard/scenes/*scene/controller[@controllerType='LISTVIEW']/sections/*section/subViews/*subView[customClass='UILabel' or customClass='MFLabel']
*****  	or
*****  	/xib-container/components/*component[customClass='UILabel' or customClass='MFLabel']
*****  
****************************************************** -->

<xsl:template match="subView[customClass='UILabel' or customClass='MFLabel']|component[customClass='UILabel' or customClass='MFLabel']" mode="subview-runtimeAttributes-generation" priority="1000">
	<xsl:comment>"subView[customClass='UILabel' or customClass='MFLabel']" mode="subview-runtimeAttributes-generation"</xsl:comment>
	
	
</xsl:template>


<xsl:template match="subView[customClass='UILabel' or customClass='MFLabel']|component[customClass='UILabel' or customClass='MFLabel']" mode="subview-outlets-generation"  priority="1000">
	<xsl:comment>subView|component[customClass='UILabel' or customClass='MFLabel']" mode="subview-outlets-generation"</xsl:comment>
		<!--  xsl:if test="$controllerId!=''">
			<outlet property="delegate">
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-<xsl:value-of select="customClass"/>-SOD</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="$controllerId"/></xsl:attribute>
			</outlet>
		</xsl:if -->	
</xsl:template>

</xsl:stylesheet>