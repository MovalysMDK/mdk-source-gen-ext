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

<!-- output format of generated stylesheet -->
<xsl:output doctype-public="-//Adeuza//Movalys//DTD ENTITY 2.0//EN"
		encoding="ISO-8859-1" indent="yes" method="xml" doctype-system="entity-emam.dtd"/>

<xsl:template match="xml-entity">
	<xsl:apply-templates select="interface"/>
</xsl:template>

<xsl:template match="interface">

<entity id="{//xml-entity/name}"><xsl:text>
	</xsl:text><java-interface><xsl:value-of select="full-name"/></java-interface><xsl:text>
	</xsl:text><sql-table><xsl:value-of select="//xml-entity/class/table-name"/></sql-table><xsl:text disable-output-escaping="yes"><![CDATA[
	<!--//@non-generated-start[config]-->
]]></xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='config']"/>
<xsl:text disable-output-escaping="yes"><![CDATA[	<!--//@non-generated-end-->]]></xsl:text><xsl:text>
	</xsl:text><fields>
	<xsl:for-each select="//xml-entity/class/identifier/attribute | //xml-entity/class/attribute"><xsl:text disable-output-escaping="yes"><![CDATA[
		<field id="]]></xsl:text><xsl:value-of select="@name"/><xsl:text>" type="</xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>"</xsl:text><xsl:if test="@length"><xsl:text> size="</xsl:text><xsl:value-of select="@length"/><xsl:text>"</xsl:text></xsl:if><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
			<xsl:if test="@nullable = 'false'"><xsl:text>
			</xsl:text><required/>
			</xsl:if><xsl:text disable-output-escaping="yes"><![CDATA[
			<!--//@non-generated-start[others-]]></xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes"><![CDATA[]-->
]]></xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='others-{@name}']"/>
<xsl:text disable-output-escaping="yes"><![CDATA[			<!--//@non-generated-end-->]]></xsl:text><xsl:text>
		</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[</field>]]></xsl:text>
	</xsl:for-each><xsl:text disable-output-escaping="yes"><![CDATA[
		<!--//@non-generated-start[field]-->
]]></xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='field']"/>
<xsl:text disable-output-escaping="yes"><![CDATA[		<!--//@non-generated-end-->]]></xsl:text><xsl:text>
	</xsl:text></fields>
<xsl:text disable-output-escaping="yes"><![CDATA[
		<!--//@non-generated-start[contracts]-->
]]></xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='contracts']"/>
<xsl:text disable-output-escaping="yes"><![CDATA[		<!--//@non-generated-end-->
	]]></xsl:text>
</entity>
	
</xsl:template>

</xsl:stylesheet>