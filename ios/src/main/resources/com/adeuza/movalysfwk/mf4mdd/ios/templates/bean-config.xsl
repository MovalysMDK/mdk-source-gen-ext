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

<xsl:template match="typhoon-config">
<assembly xmlns="http://www.typhoonframework.org/schema/assembly"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.typhoonframework.org/schema/assembly  http://www.typhoonframework.org/schema/assembly.xsd">

	<description>
        Generated beans
    </description> 
    
    <xsl:comment>View model</xsl:comment>
    <xsl:apply-templates select="components/component[category = 'viewmodel']"/>
    
    <xsl:text>&#13;</xsl:text>
    
    <xsl:comment>Dataloader beans</xsl:comment>
    <xsl:apply-templates select="components/component[category = 'dataloader']"/>
    
    <xsl:text>&#13;</xsl:text>
    
    <xsl:comment>Action beans</xsl:comment>
    <xsl:apply-templates select="components/component[category = 'action']"/>
   
</assembly>
</xsl:template>


<xsl:template match="component">
	<component>
		<xsl:attribute name="class"><xsl:value-of select="className"/></xsl:attribute>
		<xsl:attribute name="key"><xsl:value-of select="key"/></xsl:attribute>
		<xsl:attribute name="scope"><xsl:value-of select="scope"/></xsl:attribute>
	</component>
</xsl:template>



<xsl:template match="*" priority="-900">
	<ERROR>[typhoon-config.xml] the XML node '<xsl:value-of select="name()"/>' is not handled in XSL templates</ERROR>
</xsl:template>


</xsl:stylesheet>