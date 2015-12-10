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
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/constructor.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="dao/dao-create.xsl"/>
<xsl:include href="dao/dao-select.xsl"/>
<xsl:include href="dao/dao-insert-update.xsl"/>
<xsl:include href="dao/dao-delete.xsl"/>
<xsl:include href="dao/dao-associations.xsl"/>
<xsl:include href="dao/method-signature/dao-deleteby.xsl"/>
<xsl:include href="dao/method-signature/dao-getby.xsl"/>
<xsl:include href="dao/method-signature/dao-getlistby.xsl"/>
<xsl:include href="dao/method-signature/dao-getnbby.xsl"/>

<xsl:template match="dao-interface">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-impl-imports" />
	<xsl:call-template name="dao-interface-imports"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:text>namespace </xsl:text><xsl:value-of select="./dao/package"/><xsl:text>{&#13;</xsl:text>
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
	<xsl:text>public interface </xsl:text><xsl:value-of select="name"/>
	<xsl:choose>
		<xsl:when test="./dao/class/@join-class = 'true'">
			<xsl:text> : IEntityDao&lt;</xsl:text><xsl:value-of select="./dao/class/implements/interface/@name"/><xsl:text>&gt; </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text> : IMIdentifiableDao&lt;</xsl:text><xsl:value-of select="./dao/class/implements/interface/@name"/><xsl:text>&gt; </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>{&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;</xsl:text>
	
	<xsl:apply-templates select="." mode="dao-create-region"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="dao-select-region"/>
	<xsl:apply-templates select="." mode="dao-insert-update"/>
	<xsl:apply-templates select="." mode="dao-delete"/>
	<xsl:apply-templates select="./dao/class/association[@type='many-to-many' and join-table]" mode="interface"/>

	<xsl:text>#region METHOD-SIGNATURE&#13;&#13;</xsl:text>

	<xsl:apply-templates select="./dao/method-signature" mode="interface"/>

	<xsl:text>#endregion&#13;&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>

	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

</xsl:stylesheet>
