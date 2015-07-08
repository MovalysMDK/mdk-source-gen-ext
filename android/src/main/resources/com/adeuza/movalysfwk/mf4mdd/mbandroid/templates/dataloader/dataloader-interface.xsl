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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/interface.xsl"/>
	<xsl:include href="getters.xsl"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="dataloader-interface">
		<xsl:apply-templates select="." mode="declare-interface"/>
	</xsl:template>
	
	<!-- RELOAD ..................................................................................................... -->
	
	<xsl:template match="dataloader-interface" mode="constants">
		<xsl:text>public enum DataLoaderPartEnum implements DataLoaderParts{&#13;</xsl:text>
		/** DATA part */
		<xsl:text>DATA</xsl:text>
		
		<xsl:if test="count(combos/combo)>0">
			<xsl:text>,&#13;</xsl:text>
		</xsl:if>
		<xsl:for-each select="combos/combo">
			<xsl:variable name="partEnum">
				<xsl:value-of select="translate(entity-attribute-name, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
			</xsl:variable>
			/** <xsl:value-of select="$partEnum"/> part */
			<xsl:value-of select="$partEnum"/>
			<xsl:if test="position()!=last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:text>&#13;</xsl:text>
		</xsl:for-each>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<!-- SUPERINTERFACES ............................................................................................ -->

	<xsl:template match="dataloader-interface[type='LIST' and synchronizable='true']" mode="superinterfaces">
		<xsl:text>SynchronisableListDataloader&lt;</xsl:text>
		<xsl:value-of select="entity-type/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dataloader-interface[type='LIST' and synchronizable='false']" mode="superinterfaces">
		<xsl:text>ListDataloader&lt;</xsl:text>
		<xsl:value-of select="entity-type/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dataloader-interface[type='SINGLE' and synchronizable='true'] | dataloader-interface[type='WORKSPACE' and synchronizable='true']" mode="superinterfaces">
		<xsl:text>SynchronisableDataLoader&lt;</xsl:text>
		<xsl:value-of select="entity-type/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dataloader-interface[type='SINGLE' and synchronizable='false'] | dataloader-interface[type='WORKSPACE' and synchronizable='false']" mode="superinterfaces">
		<xsl:text>MMDataloader&lt;</xsl:text>
		<xsl:value-of select="entity-type/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="dataloader-interface" mode="methods">
		<xsl:apply-templates select="." mode="getters-interface"/>
	</xsl:template>
</xsl:stylesheet>
