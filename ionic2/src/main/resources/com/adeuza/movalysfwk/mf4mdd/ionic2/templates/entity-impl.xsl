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

<!-- Entry point for HTML5 Entity Generation -->
	<xsl:output method="text"/>

	<xsl:include href="commons/ts-imports.xsl"/>
	<xsl:include href="commons/ts-class.xsl"/>
	<xsl:include href="commons/ts-attributes.xsl"/>
	<xsl:include href="entity/ts-imports.xsl"/>
	<xsl:include href="entity/class-heritage.xsl"/>
	<xsl:include href="entity/extra-methods.xsl"/>
	

    <xsl:template match="/">
    	<xsl:call-template  name="declare-class">
		    <xsl:with-param name="name"><xsl:value-of select="class/name"/></xsl:with-param>
		    <xsl:with-param name="heritage">true</xsl:with-param>
		    <xsl:with-param name="interface">false</xsl:with-param>
	    </xsl:call-template>
	</xsl:template>

    <!-- Body of the class -->
	<xsl:template match="node()" mode="class-body">
	
		<!-- Attributes definition -->
		<xsl:apply-templates select="." mode="attributes"/>
		
		<!-- Non Generated attributes -->
		<xsl:text>&#10;&#10;//@non-generated-start[attributes]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='attributes']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<!-- Non Generated attributes custom modifications -->
		<xsl:text>&#10;&#10;//@non-generated-start[attributes-custom-modifications]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='attributes-custom-modifications']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>

		<!--Constructor function-->
		<xsl:text>constructor() { &#10;</xsl:text>

		<xsl:text>super(); &#10;</xsl:text>

		<!-- 		All attributes are initialised differently depending on their type, if they're attributes or association, and (if association) their association's type -->		
			<!-- // IDENTIFIER ATTRIBUTES -->
			<xsl:for-each select="./identifier/attribute">
				<xsl:choose>
					<xsl:when test="@type-name='Long'">
						<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = -1;&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- // ATTRIBUTES -->
			<xsl:for-each select="./attribute[@derived='false']">
				<xsl:choose>
					<!--  if NOT enum -->
					<xsl:when test="not(@enum) or @enum = 'false'">
						<!-- 	default case -->
						<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!--  if enum -->
						<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>.</xsl:text><xsl:value-of select="enumeration-values/enum-value"/><xsl:text>;&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			
			<!-- // ASSOCIATIONS -->
			<xsl:for-each select="./association[(@type='one-to-many' or @type='many-to-many') and @opposite-navigable='true']">
				<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = [];&#10;</xsl:text>
			</xsl:for-each>
			
			<xsl:text>&#10;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">child-instantiation-factory</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:for-each select="./association[(@type='many-to-one' or (@type='one-to-one'))]">	
							<xsl:text>&#10;// uncomment the following line (and add imports) only if you want to instantiate the child object here	&#10;</xsl:text>				
							<xsl:text>//this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>} &#10;</xsl:text>

		
		<!-- Extra methods -->
		<xsl:apply-templates select="." mode="extra-methods"/>
		
		<!-- Non Generated functions -->
		<xsl:text>&#10;//@non-generated-start[functions]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='functions']" />
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<!-- Getters Setters -->
		<xsl:apply-templates select="." mode="attributes-getter-setter"/>
		
		<!-- Non Generated attributes getter-setter -->
		<xsl:text>&#10;&#10;//@non-generated-start[attributes-getter-setter]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='attributes-getter-setter']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
	</xsl:template>


</xsl:stylesheet>