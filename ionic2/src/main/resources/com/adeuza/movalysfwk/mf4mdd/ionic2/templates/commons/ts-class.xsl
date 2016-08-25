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

	<xsl:include href="commons/export-class.xsl"/>

	<!-- THIS STARTS THE CLASS -->
	<xsl:template name="declare-class">
		<xsl:param name="name" />
		<xsl:param name="heritage" />
		<xsl:param name="interface" />

		<xsl:text>'use strict'	;&#10;&#10;</xsl:text>
				
		<!-- Imports -->
		<xsl:apply-templates select="." mode="declare-imports"/>
		<xsl:text>&#10;//@non-generated-start[imports]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='imports']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<!-- tslint -->
		<xsl:text>&#10;//@non-generated-start[tslint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='tslint-override']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<!-- class XXXX extends ... -->
		<!--<xsl:text>export class </xsl:text><xsl:value-of select="name"/><xsl:apply-templates select="." mode="class-heritage"/> -->
		
		<!-- class XXXX implements ... -->
		<!--<xsl:text>export class </xsl:text><xsl:value-of select="name"/><xsl:apply-templates select="." mode="class-implements"/> -->
		<!--<xsl:text>&lt;</xsl:text><xsl:value-of select="name"/><xsl:text>&gt;</xsl:text>-->
		
		<xsl:call-template name="export-class">
				<xsl:with-param name="classname"><xsl:value-of select="$name"/></xsl:with-param>
				<xsl:with-param name="heritage"><xsl:value-of select="$heritage"/></xsl:with-param>
				<xsl:with-param name="interface"><xsl:value-of select="$interface"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="." mode="class-body"/>
		<xsl:text>};&#10;</xsl:text>
	</xsl:template>

	
	
	
	<!-- ###################################################
						TEMPLATES PAR DEFAUT
		################################################### -->		
	<xsl:template match="node()" mode="extra-methods"/>

</xsl:stylesheet>