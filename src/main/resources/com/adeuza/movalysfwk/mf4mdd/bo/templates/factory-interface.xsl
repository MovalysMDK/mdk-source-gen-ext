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

<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>	

<xsl:template match="pojo-factory-interface">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

<xsl:for-each select="//import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.Public ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntityFactory ;

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text><xsl:value-of select="name"/> : <xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:value-of select="documentation"/>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@Public 
public interface <xsl:value-of select="name"/> extends BOEntityFactory<xsl:text>&lt;</xsl:text><xsl:value-of select="interface/@name"/><xsl:text>&gt;</xsl:text> {
		
	//@non-generated-start[constants]
	<xsl:value-of select="non-generated/bloc[@id='constants']"/>
	<xsl:text>//@non-generated-end</xsl:text>

	/**
	 * Méthode de création de l'objet d'interface <xsl:value-of select="interface/@name"/> sans l'enregistrement des changements.
	 *
	 * @return <xsl:value-of select="interface/@name"/>
	 */
	public <xsl:value-of select="interface/@name"/> createInstanceNoChangeRecord();

	/**
	 * Méthode de création de l'objet d'interface <xsl:value-of select="interface/@name"/> avec l'enregistrement des changements.
	 *
	 * @return <xsl:value-of select="interface/@name"/>
	 */
	@Public
	public <xsl:value-of select="interface/@name"/> createInstance();

	//@non-generated-start[methods]
	<xsl:value-of select="non-generated/bloc[@id='methods']"/>
	<xsl:text>//@non-generated-end</xsl:text>
}
	
</xsl:template>

</xsl:stylesheet>