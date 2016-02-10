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

	<xsl:include href="attributes.xsl"/>
	<xsl:include href="reload.xsl"/>
	<xsl:include href="load.xsl"/>
	<xsl:include href="getters.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/class.xsl"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="dataloader-impl">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<xsl:template match="dataloader-impl" mode="declare-extra-imports">
		<import>java.util.Set</import>
		<xsl:apply-templates select="." mode="other-declare-extra-imports"></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="dataloader-impl[dataloader-interface/synchronizable = 'false' and count(dataloader-interface/combos/combo[entity-synchronizable = 'true']) > 0]" mode="other-declare-extra-imports">
		<xsl:choose>
			<xsl:when test="dataloader-interface/type = 'LIST'">
				<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractSynchronisableListDataloader</import>
			</xsl:when>
			<xsl:when test="dataloader-interface/type = 'SINGLE' or dataloader-interface/type = 'WORKSPACE'">
				<import>com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractSynchronisableDataLoader</import>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>

	<!-- CLASS PROTOTYPE ............................................................................................ -->

	<xsl:template match="dataloader-impl" mode="class-prototype">
		public class <xsl:value-of select="name"/>
				<xsl:apply-templates select="." mode="extends"/>
				<xsl:text>&#13;//@non-generated-start[class-signature]&#13;</xsl:text>
				<xsl:apply-templates select="." mode="implements"/>
				<xsl:text>&#13;//@non-generated-end&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="dataloader-impl" mode="extends">
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">class-signature-extends</xsl:with-param>
				<xsl:with-param name="defaultSource">
						<!-- ZONE EXTEND DE CLASS -->	
						<xsl:text> extends </xsl:text>
						<xsl:if test="dataloader-interface/type = 'LIST'">
							<xsl:choose>
							<xsl:when test="dataloader-interface/synchronizable = 'true' or count(dataloader-interface/combos/combo[entity-synchronizable = 'true']) > 0 ">
								<xsl:text>AbstractSynchronisableListDataloader</xsl:text>
							</xsl:when>
							<xsl:when test="dataloader-interface/synchronizable = 'false'">
								<xsl:text>AbstractListDataloader</xsl:text>
							</xsl:when>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="dataloader-interface/type = 'SINGLE' or dataloader-interface/type = 'WORKSPACE' ">
							<xsl:choose>
							<xsl:when test="dataloader-interface/synchronizable = 'true' or count(dataloader-interface/combos/combo[entity-synchronizable = 'true']) > 0 ">
								<xsl:text>AbstractSynchronisableDataLoader</xsl:text>
							</xsl:when>
							<xsl:when test="dataloader-interface/synchronizable = 'false'">
								<xsl:text>AbstractDataloader</xsl:text>
							</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:text>&lt;</xsl:text>
						<xsl:value-of select="dataloader-interface/entity-type/name"/> 
						<xsl:text>&gt; </xsl:text>
						<xsl:text>&#13;</xsl:text>
				</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="dataloader-impl" mode="methods">
		<xsl:apply-templates select="." mode="allReload"/>
		<xsl:apply-templates select="." mode="loadMethod"/>
		<xsl:apply-templates select="." mode="getters"/>

		<xsl:if test="dataloader-interface/synchronizable = 'true' or count(dataloader-interface/combos/combo[entity-synchronizable = 'true']) > 0">
			/**
			  * {@inheritDoc}
			  */
			@Override
			protected CascadeSet getLoadCascadeForMe() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-load-cascade-for-me</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:choose>
					<xsl:when test="dataloader-interface/entity-type/transient = 'false'">
						return LOAD_CASCADE ;
					</xsl:when>
					<xsl:otherwise>
						return CascadeSet.of(
						<xsl:for-each select="cascades/cascade">
							<xsl:value-of select="name"/>
							<xsl:if test="position() != last()">
								<xsl:text>,</xsl:text>
							</xsl:if>
						</xsl:for-each> 
						);				
					</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			}
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
