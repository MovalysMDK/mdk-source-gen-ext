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

	<xsl:output method="text" />

	<!-- generate getters -->
	<xsl:template match="dataloader-impl" mode="getters">
		<xsl:for-each select="dataloader-interface/combos/combo">
			<xsl:text>/**&#13;</xsl:text>
			<xsl:text> * {@inheritDoc}&#13;</xsl:text>
			<xsl:text> */&#13;</xsl:text>
			<xsl:text>@Override&#13;</xsl:text>
			<xsl:text>public List&lt;</xsl:text>
			<xsl:value-of select="entity"/>
			<xsl:text>&gt; getList</xsl:text>
			<xsl:value-of select="entity-getter-name"/>
			<xsl:text>() {&#13;</xsl:text>
			<xsl:text>return this.</xsl:text>
			<xsl:value-of select="entity-attribute-name"/>
			<xsl:text>;&#13;</xsl:text>
			<xsl:text>}&#13;&#13;</xsl:text>
		</xsl:for-each>
	</xsl:template>

	<!-- generate getters -->
	<xsl:template match="dataloader-interface" mode="getters-interface">
		<xsl:for-each select="combos/combo">
			<xsl:text>/**&#13;</xsl:text>
			<xsl:text> * Return a list of</xsl:text>
			<xsl:value-of select="entity"/>
			<xsl:text>&#13;</xsl:text>
			<xsl:text> * @return list of &lt;code&gt;</xsl:text>
			<xsl:value-of select="entity"/>
			<xsl:text>&lt;/code&gt; object&#13;</xsl:text>
			<xsl:text> */&#13;</xsl:text>
			<xsl:text>public List&lt;</xsl:text>
			<xsl:value-of select="entity"/>
			<xsl:text>&gt; getList</xsl:text>
			<xsl:value-of select="entity-getter-name"/>
			<xsl:text>();&#13;&#13;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>