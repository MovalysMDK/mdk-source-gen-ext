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

	<xsl:include href="includes/interface.xsl"/>

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="viewmodel-interface"/>
	</xsl:template>

	<xsl:template match="viewmodel-interface">
		<xsl:apply-templates select="." mode="declare-viewmodel-interface"/>
	</xsl:template>

	<xsl:template match="viewmodel-interface" mode="declare-viewmodel-interface">
		package <xsl:value-of select="package"/>;

		<xsl:apply-templates select="." mode="declare-imports"/>

		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:apply-templates select="." mode="class-annotations"/>
		<xsl:text>public interface </xsl:text><xsl:value-of select="name"/>
				<xsl:apply-templates select="." mode="extends"/>
				//@non-generated-start[class-signature]
				<xsl:value-of select="/*/non-generated/bloc[@id='class-signature']"/>
				<xsl:text>//@non-generated-end</xsl:text>
		{
			<xsl:apply-templates select="." mode="constants"/>

			//@non-generated-start[constants]
			<xsl:value-of select="/*/non-generated/bloc[@id='constants']"/>
			<xsl:text>//@non-generated-end&#13;&#13;</xsl:text>

			<xsl:apply-templates select="method-signature[options[not(option[@name='attribute']='id_id') and not(option[@name='attribute']='id_identifier')]]" mode="declare-method"/>
			<xsl:apply-templates select="." mode="methods"/>

			//@non-generated-start[methods]
			<xsl:value-of select="/*/non-generated/bloc[@id='methods']"/>
			<xsl:value-of select="/*/non-generated/bloc[@id='methodes']"/>
			<xsl:text>//@non-generated-end</xsl:text>
		}
	</xsl:template>

	<xsl:template match="viewmodel-interface" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel</import>
		<xsl:if test="not(type-to-update)">
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ViewModel</import>
		</xsl:if>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.Scope</import>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.ScopePolicy</import>
		
		<xsl:choose>
			<xsl:when test="method-signature[options/option[@name='attribute']='id_id']">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ItemViewModelId</import>
			</xsl:when>
			<xsl:when test="method-signature[options/option[@name='attribute']='id_identifier']">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ItemViewModelIdentifier</import>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- ANNOTATIONS ............................................................................................. -->

	<xsl:template match="viewmodel-interface" mode="class-annotations">
		<xsl:choose>
			<xsl:when test="/viewmodel/parent-viewmodel/parent-viewmodel">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='LIST_1__ONE_SELECTED'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='FIXED_LIST'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/type/name='LISTITEM_1'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when> 
			<xsl:when test="/viewmodel/type/name='LISTITEM_2'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when> 
			<xsl:when test="/viewmodel/type/name='LISTITEM_3'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:when test="/viewmodel/multiInstance='true'">
				<xsl:text>@Scope(ScopePolicy.PROTOTYPE)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>@Scope(ScopePolicy.SINGLETON)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EXTENDS ................................................................................................. -->
	
	<xsl:template match="viewmodel-interface" mode="extends">
		<xsl:choose>
			<xsl:when test="not(type-to-update)">
				<xsl:text> extends ViewModel</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="superinterfaces">
					<xsl:apply-templates select="." mode="superinterfaces"/>
				</xsl:variable>
		
				<xsl:if test="string-length($superinterfaces) > 0">
					<xsl:text> extends </xsl:text>
					<xsl:value-of select="$superinterfaces"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="method-signature[options/option[@name='attribute']='id_id']">
						<xsl:text>, ItemViewModelId</xsl:text>
					</xsl:when>
					<xsl:when test="method-signature[options/option[@name='attribute']='id_identifier']">
						<xsl:text>, ItemViewModelIdentifier</xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- METHODS .................................................................................................. -->
	
	<xsl:template match="viewmodel-interface/method-signature" mode="declare-method-documentation">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * </xsl:text>
		<xsl:value-of select="@type"/><xsl:text>ter method for </xsl:text><xsl:value-of select="./options/option[@name='attribute']"/>
		<xsl:text>&#13; * </xsl:text><xsl:value-of select="./javadoc"/>
		<xsl:choose>
			<xsl:when test="@type='get'"><xsl:text>value of </xsl:text><xsl:value-of select="./options/option[@name='attribute']"/></xsl:when>
			<xsl:otherwise><xsl:text> the value to set</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13; */&#13;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
