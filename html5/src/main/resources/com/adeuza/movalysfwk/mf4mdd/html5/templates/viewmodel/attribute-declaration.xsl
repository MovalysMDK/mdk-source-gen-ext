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
	
	<xsl:template match="node()" mode="attribute-declaration">
	
		<!-- attribut propre au viewmodel -->
		<xsl:for-each select="identifier/attribute | attribute">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:value-of select="documentation/doc-attribute"/><xsl:text>&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/><xsl:text>&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]>&#10;</xsl:text>
			<xsl:text> * &#10;</xsl:text>
			</xsl:if>
			<xsl:text> */&#10;</xsl:text>
			<xsl:text>var _</xsl:text><xsl:value-of select="@name"/><xsl:text> = null;&#10;</xsl:text>
			
			
			<xsl:if test="@derived = 'true'">
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">derived-attribute-<xsl:value-of select="@name"/>-setting</xsl:with-param>
					<xsl:with-param name="defaultSource">
						<xsl:text>&#10;//Calculate here the value of the derived attribute. Please call the function update</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>(); at the end of all setters of the variables you add here&#10;</xsl:text>
						<xsl:text>var update</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> = function() { _</xsl:text><xsl:value-of select="@name"/><xsl:text> = '';};&#10;</xsl:text>
					    <xsl:text>update</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>();&#10;</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		
		<!-- attribut de sous viewmodel - DECLARATION LIST  -->
		<xsl:if test="is-screen-viewmodel='false'">
			<xsl:apply-templates select="subvm/viewmodel" mode="subvm-attribute-declaration"/>
		</xsl:if>

		
		<!-- attribut de external viewmodel - DECLARATION COMBOBOC  -->
		<xsl:for-each select="mapping/entity[@mapping-type='vm_comboitemselected']">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:text>Combobox</xsl:text><xsl:text>&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:value-of select="@vm-attr"/><xsl:text>&#10;</xsl:text>
			<xsl:text> * &#10;</xsl:text>
			<xsl:text> */&#10;</xsl:text>
			<xsl:text>var _</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text> = null;&#10;</xsl:text>
		</xsl:for-each>
		
	</xsl:template>
	
	
	<xsl:template match="viewmodel[type/name = 'FIXED_LIST']" mode="subvm-attribute-declaration">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:text>subviewmodel</xsl:text><xsl:text>&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:value-of select="property-name"/><xsl:text>&#10;</xsl:text>
			<xsl:text> * &#10;</xsl:text>
			<xsl:text> */&#10;</xsl:text>
			<xsl:text>var _lst</xsl:text>
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text> = null;&#10;</xsl:text>	
	</xsl:template>
	
	<xsl:template match="viewmodel[type/name = 'LISTITEM_1' or type/name = 'LISTITEM_2' or type/name = 'LISTITEM_3']"
		mode="subvm-attribute-declaration">
			<xsl:text>/**&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:text>subviewmodel</xsl:text><xsl:text>&#10;</xsl:text>
			<xsl:text> * </xsl:text><xsl:value-of select="property-name"/><xsl:text>&#10;</xsl:text>
			<xsl:text> * &#10;</xsl:text>
			<xsl:text> */&#10;</xsl:text>
			<xsl:text>var _list = null;&#10;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="annotation">
<!-- 		<xsl:text>@</xsl:text> -->
<!-- 		<xsl:value-of select="@name"/> -->
<!-- 		<xsl:text>&#10;</xsl:text> -->
	</xsl:template>

</xsl:stylesheet>