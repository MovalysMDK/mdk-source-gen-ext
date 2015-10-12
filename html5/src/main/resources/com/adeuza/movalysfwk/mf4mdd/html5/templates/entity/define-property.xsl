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
	

<xsl:output method="text"/>	

<xsl:template match="class" mode="define-property">

           
    <xsl:text>/**&#10;* define and initialize all of the attributes of the class </xsl:text><xsl:value-of select="../../name"/>
	<xsl:text>  &#10;*/</xsl:text>
    <xsl:text>Object.defineProperties(this, {&#10;</xsl:text>
    
	<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
         <xsl:text>&#10;'</xsl:text><xsl:value-of select="@name"/><xsl:text>': {&#10;</xsl:text>
                 
         <xsl:apply-templates select="." mode="define-getter-method"/>
         <xsl:apply-templates select="." mode="define-setter-method"/>
         
         <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>attribute-</xsl:text><xsl:value-of select="@name"/><xsl:text>-settings</xsl:text></xsl:with-param>
			<xsl:with-param name="defaultSource">
         		<xsl:text>&#10;&#10;enumerable:true,&#10;configurable:false&#10;</xsl:text>
	        </xsl:with-param>
		</xsl:call-template>
	
         <xsl:text>&#10;}</xsl:text>
         
         <xsl:if test="parent::identifier">
        	 <xsl:apply-templates select="." mode="define-idToString-property"/>
         </xsl:if>
         
         <xsl:if test="position() != last()">
		 	<xsl:text>,&#10;</xsl:text>
		 </xsl:if>
		 <xsl:text>&#10;</xsl:text>
	</xsl:for-each>
	
	<xsl:text>&#10;});&#10;</xsl:text>
    
</xsl:template>


<xsl:template match="*" mode="define-getter-method">
	<xsl:text>get: function () {&#10;</xsl:text>
	
	<xsl:variable name="defineGetterAttribute"><xsl:text>getter-</xsl:text><xsl:value-of select="@name"/></xsl:variable>
	<xsl:text>&#10;//@non-generated-start[getter-</xsl:text><xsl:value-of select="@name"/><xsl:text>]&#10;</xsl:text>
	<xsl:value-of select="/*/non-generated/bloc[@id=$defineGetterAttribute]"/>
	<xsl:text>//@non-generated-end&#10;</xsl:text>

	<xsl:text>return _</xsl:text><xsl:value-of select="@name"/>;

	<xsl:text>},&#10;</xsl:text>
</xsl:template>


<xsl:template match="*" mode="define-setter-method">
	<xsl:text>set: function (</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>) {&#10;</xsl:text>
	<xsl:if test="(name() = 'attribute' and not(parent::association)) or (name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))">
		<xsl:text>_</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="parameter-name"/><xsl:text>;&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)">
		<xsl:text>_</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="parameter-name"/><xsl:text>;&#10;</xsl:text>
	</xsl:if>
	<xsl:variable name="setter" select="concat('setter-', @name)"/>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId"><xsl:text>setter-</xsl:text><xsl:value-of select="@name"/></xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="../attribute" mode="call-derived-attr-update"></xsl:apply-templates>
        </xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>&#10;},&#10;</xsl:text>
		
</xsl:template>

<xsl:template match="attribute[@derived = 'true']" mode="call-derived-attr-update">
		<xsl:text>update</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>();&#10;</xsl:text>
</xsl:template>
<xsl:template match="attribute[@derived = 'false']" mode="call-derived-attr-update">
</xsl:template>
<xsl:template match="*" mode="call-derived-attr-update" priority="-999">
	<xsl:comment>ERROR OF XSL: this template should never be applied</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="define-idToString-property">
 	<xsl:text>,&#10;&#10;'idToString':{&#10;</xsl:text>
    <xsl:text>get: function () {&#10;</xsl:text>
    <xsl:text>return _</xsl:text><xsl:value-of select="@name"/><xsl:text>;&#10;</xsl:text>
    <xsl:text>},&#10;</xsl:text>
    <xsl:text>enumerable: false,&#10;</xsl:text>
    <xsl:text>configurable: false&#10;</xsl:text>
    <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>