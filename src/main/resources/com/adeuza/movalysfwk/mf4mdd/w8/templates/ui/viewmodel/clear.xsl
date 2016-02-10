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

<!-- CLEAR VM ............................................................................. -->
<xsl:template match="mapping" mode="generate-method-clear-header">
	<xsl:apply-templates select=".//entity[not(@mapping-type)]" mode="generate-method-clear-header">
		<xsl:sort select="@type"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="entity" mode="generate-method-clear-header">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Clear datas associated to a </xsl:text><xsl:value-of select="@type"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>void Clear</xsl:text>
	<xsl:call-template name="string-uppercase-firstchar">
		<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
	</xsl:call-template>
	<xsl:text>();&#13;</xsl:text>
</xsl:template>

<xsl:template match="mapping" mode="generate-method-clear">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void Clear(){</xsl:text>
	<xsl:apply-templates select="../attribute[@derived='true']" mode="generate-method-clear"/>
	<xsl:apply-templates select="attribute" mode="generate-call-clear"/>
	<xsl:apply-templates select="./.." mode="generate-call-clear"/>
	<xsl:apply-templates select="entity[@mapping-type]" mode="generate-call-clear"/>
	<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>this.IsDirty = false;&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">clear-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>}&#13;</xsl:text>

	<xsl:apply-templates select=".//entity[not(@mapping-type)]" mode="generate-method-clear">
		<xsl:sort select="@type"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="attribute[@derived='true']" mode="generate-method-clear">
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@name-capitalized"/>
	<xsl:choose>
		<xsl:when test="contains(@name-capitalized,'_id')='true'">
			<xsl:text> = </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>.Value = </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="@init"/>
	<xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="entity[@mapping-type='vm']" mode="generate-call-clear">
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> = </xsl:text>
	<xsl:value-of select="@initial-value"/>
	<xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="entity[@mapping-type='vmlist']" mode="generate-call-clear">
	<xsl:text>this.Lst</xsl:text>
	<xsl:value-of select="@vm-type"/>
	<xsl:text> = null ;</xsl:text>
</xsl:template>

<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="generate-call-clear">

</xsl:template>

<xsl:template match="entity[not(@mapping-type)]" mode="generate-method-clear">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Clear datas associated to a </xsl:text><xsl:value-of select="@type"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public void Clear</xsl:text>
	<xsl:variable name="entityname"><xsl:call-template name="string-uppercase-firstchar">
	<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
	</xsl:call-template></xsl:variable>
	<xsl:value-of select="$entityname"/>
	<xsl:text>(){</xsl:text>
	<xsl:apply-templates select="attribute" mode="generate-call-clear"/>
	<xsl:apply-templates select="entity[@mapping-type]" mode="generate-call-clear"/>
	<xsl:apply-templates select="entity[not(@mapping-type)]" mode="generate-call-clear"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">clear-after-<xsl:value-of select="$entityname"/></xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>

	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="subvm" mode="generate-method-clear">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void Clear(){&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">clear-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>

	<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
<xsl:template match="viewmodel" mode="generate-call-clear">
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="property-name"/>
	<xsl:text>.Clear();</xsl:text>
</xsl:template>


<xsl:template match="entity[not(@mapping-type)]" mode="generate-call-clear">
	<xsl:if test="not(count(../../external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED'])>0)">
		<xsl:text>	this.Clear</xsl:text>
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="concat(../getter/@name , getter/@name)"/>
		</xsl:call-template>
		<xsl:text>();</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="attribute" mode="generate-call-clear">
	<xsl:text>this.</xsl:text>
	<xsl:variable name="vm-attr">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="@vm-attr"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$vm-attr"/>
	<xsl:choose>
		<xsl:when test="contains(@vm-attr,'_id')='true'">
			<xsl:text> = </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>.Value = </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="count(vm-attr-initial-value) > 0 and vm-attr-initial-value != 'nil'">
			<xsl:value-of select="vm-attr-initial-value"/>
		</xsl:when>
		<xsl:when test="@initial-value='nil' or @initial-value=''">
			<xsl:text>null</xsl:text>
		</xsl:when>

		<xsl:when test="getter/@formula">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="getter/@formula"/>
				<xsl:with-param name="replace" select="'VALUE'"/>
				<xsl:with-param name="by" select="@initial-value"/>
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="@initial-value"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>;</xsl:text>
</xsl:template>

<!--  Cas d'une pickerlist -->
<xsl:template match="viewmodel" mode="generate-call-clear">
	<xsl:apply-templates select="external-lists/external-list/viewmodel" mode="generate-call-clear-for-pickerlist"/>	
</xsl:template>
		
		
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-call-clear-for-pickerlist">
	<xsl:param name="var-parent-entity">entity</xsl:param>
	<xsl:text>this.Selected</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text> = null ;</xsl:text>

   	<xsl:text>if(this.Lst</xsl:text><xsl:value-of select="implements/interface/@name"/>
	<xsl:text> != null &amp;&amp; this.Lst</xsl:text><xsl:value-of select="implements/interface/@name"/>
	<xsl:text>.ListViewModel != null &amp;&amp; this.Lst</xsl:text><xsl:value-of select="implements/interface/@name"/>
	<xsl:text>.ListViewModel.Count > 0) {&#13;&#13; this.Selected</xsl:text>
	<xsl:value-of select="type/item"/>
	<xsl:text> = (dynamic) this.Lst</xsl:text><xsl:value-of select="implements/interface/@name"/>
	<xsl:text>.ListViewModel.ToList().FirstOrDefault();}&#13;</xsl:text>

</xsl:template>
	
<!-- 	Cas d'une pickerlist a l'intérieur d'une fixedlist -->
<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="generate-call-clear">
	<xsl:param name="var-parent-entity">entity</xsl:param>
	<xsl:if test="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
	
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
	    <xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/><xsl:text>&gt;();</xsl:text>
	    <xsl:text>if (o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
	    <xsl:text>.Lst</xsl:text>
	    <xsl:value-of select="external-lists/external-list/viewmodel/implements/interface/@name"/>
	    <xsl:text> != null &amp;&amp; o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
	    <xsl:text>.Lst</xsl:text>
	    <xsl:value-of select="external-lists/external-list/viewmodel/implements/interface/@name"/>
	    <xsl:text>.ListViewModel != null &amp;&amp; o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
	    <xsl:text>.Lst</xsl:text>
	    <xsl:value-of select="external-lists/external-list/viewmodel/implements/interface/@name"/>
	    <xsl:text>.ListViewModel.Count > 0) {this.Selected</xsl:text>
		<xsl:value-of select="external-lists/external-list/viewmodel/type/item"/>
	    <xsl:text> = (dynamic) o</xsl:text>
		<xsl:value-of select="parent-viewmodel/parent-viewmodel/master-interface/@name"/>
	    <xsl:text>.Lst</xsl:text>
	    <xsl:value-of select="external-lists/external-list/viewmodel/implements/interface/@name"/>
	    <xsl:text>.ListViewModel.ToList().FirstOrDefault();}&#13;</xsl:text>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>