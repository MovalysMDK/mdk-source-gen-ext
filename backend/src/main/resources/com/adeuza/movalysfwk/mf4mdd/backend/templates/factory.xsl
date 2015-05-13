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

<xsl:template match="pojo-factory">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.BeanService;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet;

<xsl:for-each select="//import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.AbstractBOEntityFactory;

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
@BeanService("<xsl:value-of select="pojo-factory-interface/bean-name"/>")
public class <xsl:value-of select="name"/> extends AbstractBOEntityFactory&lt;<xsl:value-of select="interface/@name"/>&gt; implements <xsl:value-of select="pojo-factory-interface/name"/> {
	
	//@non-generated-start[attributes]
	<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
	<xsl:text>//@non-generated-end</xsl:text>
	
	
	/**
	 * Constructor <xsl:value-of select="name"/>
	 */
	private <xsl:value-of select="name"/>(){
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see <xsl:value-of select="package"/>.<xsl:value-of select="pojo-factory-interface/name"/>#createInstanceNoChangeRecord()
	 */
	public <xsl:value-of select="interface/@name"/> createInstanceNoChangeRecord(){
		<xsl:value-of select="interface/@name"/> r_o<xsl:value-of select="interface/@name"/> = new <xsl:value-of select="class/name"/>();
		this.init(r_o<xsl:value-of select="interface/@name"/>);
		return r_o<xsl:value-of select="interface/@name"/>;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see <xsl:value-of select="package"/>.<xsl:value-of select="pojo-factory-interface/name"/>#createInstance()
	 */
	public <xsl:value-of select="interface/@name"/> createInstance(){
		<xsl:value-of select="interface/@name"/> r_o<xsl:value-of select="interface/@name"/> = new <xsl:value-of select="class/name"/>();
		this.init(r_o<xsl:value-of select="interface/@name"/>);
		//DISABLED IN BACKPORT
		//r_o<xsl:value-of select="interface/@name"/>.startRecordChanges(CascadeSet.ALL);
		return r_o<xsl:value-of select="interface/@name"/>;
	}

	/**
	 * Méthode d'initialisation de l'objet
	 *
	 * @param p_o<xsl:value-of select="interface/@name"/> Entité d'interface <xsl:value-of select="interface/@name"/>
	 */
	protected void init(<xsl:value-of select="interface/@name"/> p_o<xsl:value-of select="interface/@name"/>){
		//@non-generated-start[init]
		<xsl:value-of select="non-generated/bloc[@id='init']"/>
		<xsl:text>//@non-generated-end</xsl:text>
	}

	//@non-generated-start[methods]
	<xsl:value-of select="non-generated/bloc[@id='methods']"/>
	<xsl:text>//@non-generated-end</xsl:text>
}
	
</xsl:template>

</xsl:stylesheet>