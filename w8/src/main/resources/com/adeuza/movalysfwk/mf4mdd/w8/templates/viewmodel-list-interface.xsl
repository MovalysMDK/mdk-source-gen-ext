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

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/interface.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>
<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/modifyToIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>

<xsl:template match="viewmodel">
	
	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	<xsl:call-template name="viewmodel-imports" />
	
	<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.</xsl:text>
	<xsl:choose>
		<xsl:when test="type/name='MASTER' or type/name='LIST_2' or type/name='FIXED_LIST'">
			<xsl:text>Singleton</xsl:text>
		</xsl:when>
		<xsl:when test="type/name='LIST_1'">
			<xsl:apply-templates select="." mode="generate-scopepolicy"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Prototype</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>)]&#13;</xsl:text>
	<xsl:text>public interface </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> : </xsl:text>
	<!-- <xsl:choose>
		<xsl:when test="./type/name='FIXED_LIST' and ./type/conf-name='photo'">
			<xsl:text>IMFPhotoListViewModel</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>IListViewModel</xsl:text>
		</xsl:otherwise>
	</xsl:choose> -->
	<xsl:value-of select="./type/list"/>
	<xsl:text>{&#13;</xsl:text>
	
	<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
	<xsl:value-of select="/*/non-generated/bloc[@id='class-signature']"/>
	<xsl:text>&#13;//@non-generated-end&#13;</xsl:text>
	
	<xsl:text>&#13;#region Properties&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text>

	<xsl:if test="parent-viewmodel[@type = 'MASTER']">
		<xsl:text>void Execute</xsl:text><xsl:value-of select="uml-name"/><xsl:text>NavigationDetail(object parameter);&#13;</xsl:text>
	</xsl:if>

	<xsl:if test="dataloader-impl">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Update the view model with the given data loader.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="p_dataloader"&gt; Data loader to retrieve the information to insert in the view model.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>void UpdateFromDataLoader(</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/name"/><xsl:text> p_dataloader);
	</xsl:text>
	</xsl:if>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="node()" mode="importEntity">
	<xsl:value-of select="@header"/>
</xsl:template>

<xsl:template match="attribute" mode="vmAttributes">
	<xsl:text>MFProperty&lt;</xsl:text>
	<xsl:value-of select="@type-short-name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-combo-attribute">
	<xsl:text>MFProperty&lt;</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text>&gt; Selected</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
	
	<xsl:text>MFProperty&lt;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text>&gt; Lst</xsl:text>
	<xsl:value-of select="implements/interface/@name"/>
	<xsl:text> { get; set; }&#13;</xsl:text>
	
</xsl:template>

<xsl:template match="viewmodel" mode="generate-combo-attribute">
</xsl:template>

<xsl:template match="viewmodel" mode="subVmAttributes">
	<xsl:text>MFProperty&lt;</xsl:text>
	<xsl:value-of select="name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="property-name"/>
	<xsl:text> { get; set; }&#13;</xsl:text>

</xsl:template>

<xsl:template match="viewmodel[not(parent-viewmodel)]" mode="generate-scopepolicy">
	<xsl:text>Singleton</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[parent-viewmodel[@type!='LISTITEM_2']]" mode="generate-scopepolicy">
	<xsl:text>Singleton</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-scopepolicy">
	<xsl:text>Prototype</xsl:text>
</xsl:template>

</xsl:stylesheet>