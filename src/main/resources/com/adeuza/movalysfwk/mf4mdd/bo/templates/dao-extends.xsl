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

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="dao-extends">

<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.BeanService;

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Classe de DAO : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@SuppressWarnings("unchecked")
@BeanService("<xsl:value-of select="bean-name"/>")
public class <xsl:value-of select="name"/> extends <xsl:value-of select="dao/name"/> implements <xsl:value-of select="dao-interface/name"/> {

//@non-generated-start[class]
<xsl:value-of select="non-generated/bloc[@id='class']"/>
<xsl:text>//@non-generated-end</xsl:text>

}
</xsl:template>

</xsl:stylesheet>
