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

<xsl:template match="pojo">
	<xsl:apply-templates select="interface"/>
</xsl:template>

<xsl:template match="interface">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.ICascade;
import com.adeuza.movalysfwk.mf4jcommons.core.beans.MEntity;

<xsl:variable name="current-package" select="package"/>
<xsl:for-each select="//pojo/class/descendant::association[not(parent::association)]/@cascade-name | //pojo/class/descendant::association[not(parent::association)]/@joinclass-cascade-name">
	<xsl:if test="concat($current-package, '.', ../interface/name) != ../interface/full-name">
		<xsl:text>import </xsl:text><xsl:value-of select="../interface/full-name"/><xsl:text>;&#13;</xsl:text>
	</xsl:if>
</xsl:for-each>

/**
 * Enumération de la cascade associée aux objets de type <em><xsl:value-of select="name"/></em>.
 */
public enum <xsl:value-of select="name"/>Cascade implements ICascade {
	<xsl:for-each select="//pojo/class/descendant::association[not(parent::association)]/@cascade-name | //pojo/class/descendant::association[not(parent::association)]/@joinclass-cascade-name">
		<xsl:if test="position() != 1">
			<xsl:text>,</xsl:text>
		</xsl:if>

		/**
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade <xsl:value-of select="."/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		<xsl:if test="name() = 'joinclass-cascade-name'">
			* <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade représentant l'association entre les deux entités uniquement.<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
			* <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Ajouter la cascade <xsl:value-of select="../@cascade-name"/><xsl:text> pour une cascade complète.</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="name() = 'cascade-name' and ../@joinclass-cascade-name">
			* <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>La cascade <xsl:value-of select="../@joinclass-cascade-name"/>
			<xsl:text> est un pré-requis à cette cascade</xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		 *<xsl:text> </xsl:text>
		 <!-- type de relation -->
		<xsl:if test="../@type = 'many-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="../@type = 'one-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="../@type = 'one-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="../@type = 'many-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<!-- objet cible -->
		<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> targetEntity=</xsl:text>
		<xsl:value-of select="../interface/name"/>
		<!-- obligatoire -->
		<xsl:if test="../@type = 'many-to-one' or ../@type = 'one-to-one'">
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="../@optional != 'true'"/>
		</xsl:if>
		<!-- proprietaire de la relation -->
		<xsl:text> relationOwner=</xsl:text>
		<xsl:value-of select="../@relation-owner"/>
		<!-- transient -->
		<xsl:text> transient=</xsl:text>
		<xsl:value-of select="../@transient"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 */
		<xsl:value-of select="."/>(<xsl:value-of select="../interface/name"/>.class )
	</xsl:for-each>

	<xsl:if test="../class[customizable='true']">
		<xsl:text>, </xsl:text>
		/**
		 * Cascade destiné à ne pas récupérer les champs personnalisés
		 */
		<xsl:text>CUSTOM_FIELDS(null)</xsl:text>
	</xsl:if>

	<xsl:text>;</xsl:text>
	
	<xsl:text>/** Type of the targeted entity */
		private Class&lt;?  extends MEntity&gt; oResultType ;
	</xsl:text>

	/**
	 * Constructor for <xsl:value-of select="name"/>Cascade
	 * @param p_oResultEntityClass the class of the linked entity
	 */
	<xsl:text>private </xsl:text><xsl:value-of select="name"/><xsl:text>Cascade ( Class&lt;? extends MEntity&gt; p_oResultEntityClass ) {
		oResultType = p_oResultEntityClass;
	}
	/**
	 * {@inheritDoc}
	 */
	@Override
	public Class&lt;? extends MEntity&gt; getResultType(){
		return oResultType ;
	} 
	</xsl:text>
}
</xsl:template>
</xsl:stylesheet>
