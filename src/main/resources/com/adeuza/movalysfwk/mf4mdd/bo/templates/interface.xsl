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

<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.Public ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.ICascade;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.IAttribute;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CloneSession;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CloneException;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MergeException;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod;

<xsl:if test="../class/@join-class = 'true'">import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOPersistableEntity;</xsl:if>
<xsl:text>
</xsl:text>
<xsl:text>//@non-generated-start[imports]
</xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Interface : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:value-of select="//pojo/class/documentation"/>
 * 
 * <xsl:for-each select="//pojo/class/stereotypes/stereotype/documentation">
 *	<xsl:value-of select="."/>
 * </xsl:for-each>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@Public
public interface <xsl:value-of select="name"/>
<xsl:text> extends </xsl:text>
<xsl:for-each select="linked-interface">
	<xsl:value-of select="name"/>
	<xsl:if test="count(generic-parameters/param) > 0">
		<xsl:text><![CDATA[<]]></xsl:text>
		<xsl:for-each select="generic-parameters/param">
			<xsl:value-of select="../../../name"/>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text><![CDATA[>]]></xsl:text>
	</xsl:if>
	<xsl:if test="position() != last()">
		<xsl:text>,</xsl:text>
	</xsl:if>
</xsl:for-each>
<xsl:if test="../class/@join-class = 'true'">BOEntity</xsl:if>
<xsl:text>
//@non-generated-start[class-signature]
</xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='class-signature']"/>
<xsl:text>//@non-generated-end</xsl:text>
{

	/**
	 * Constante indiquant le nom de l'entité
	 */
	@Public
	public static final String ENTITY_NAME = "<xsl:value-of select="//pojo/interface/name"/>";
 
	/**
	 * Enumération de la cascade
	 */<!-- génération de l'enum de la cascade -->
	@Public
	public enum Cascade implements ICascade {
		/**
		 * Cascade NOT_DYN
		 */
		NOT_DYN,
		/**
		 * Cascade REFERENCES
		 */
		REFERENCES<xsl:if test="//pojo/class/descendant::association[not(parent::association)]/@cascade-name | //pojo/class/descendant::association[not(parent::association)]/@joinclass-cascade-name">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:for-each select="//pojo/class/descendant::association[not(parent::association)]/@cascade-name | //pojo/class/descendant::association[not(parent::association)]/@joinclass-cascade-name">
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
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 */
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
		</xsl:for-each>
	}

	/**
	 * Enumération des attributs
	 */<!-- génération de l'enum de la cascade -->
	@Public
	public enum ATTRIBUTES implements IAttribute {<xsl:for-each select="//pojo/class/identifier/attribute | //pojo/class/attribute |  //pojo/class/identifier/association | //pojo/class/association ">
		<xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="@name-uppercase"/>
		/**
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 *<xsl:text> </xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> type=</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> mandatory=</xsl:text>
		<xsl:value-of select="@nullable = 'false'"/>
		<xsl:if test="@unique and @unique='true'">
			<xsl:text> unique=</xsl:text>
			<xsl:value-of select="@unique and @unique='true'"/>
		</xsl:if>
		<xsl:if test="@unique-key">			
			<xsl:variable name="unique-key" select="@unique-key"/>
			<xsl:text> unique-key=true</xsl:text>
			<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
			<xsl:text> unique-key-relation=</xsl:text>
			
			<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and @name-uppercase!=$name] | //pojo/class/attribute[@unique-key=$unique-key and @name-uppercase!=$name]">
				<xsl:value-of select="@name-uppercase"/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 */
		<xsl:value-of select="@name-uppercase"/>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
		</xsl:if>
		<xsl:if test="name()= 'association' and  (@type='many-to-one' or @type='one-to-one')">
		/**
		 * Attribute <xsl:value-of select="@cascade-name"/>
		 *<xsl:text> </xsl:text>
		 */
		<xsl:value-of select="@cascade-name"/>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
		
		</xsl:if>
		</xsl:for-each>
<xsl:text>
</xsl:text>
<xsl:text>//@non-generated-start[attributes]
</xsl:text>
<xsl:value-of select="../non-generated/bloc[@id='attributes']"/>
<xsl:text>//@non-generated-end</xsl:text>
	}

	<xsl:call-template name="create-method-signature"/>
	<!-- xsl:apply-templates select="method-signature"/-->
	
	<xsl:if test="../class/@join-class = 'true'">
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="../class/left-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="../class/left-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	@Public
	public String <xsl:value-of select="../class/left-association/name-for-join-class"/>IdToString();
	 
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="../class/right-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="../class/right-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	@Public
	public String <xsl:value-of select="../class/right-association/name-for-join-class"/>IdToString();
	</xsl:if>
	
//@non-generated-start[methods]
<xsl:value-of select="../non-generated/bloc[@id='methods']"/>
<xsl:text>//@non-generated-end</xsl:text>
}
	
</xsl:template>

<xsl:template name="create-method-signature">
	<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
	/**<xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>
	* <xsl:value-of select="documentation/doc-getter"/>
	*
	* <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 	*<xsl:text> </xsl:text>
	 	<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> type=</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> mandatory=</xsl:text>
		<xsl:value-of select="@nullable = 'false'"/>
		<xsl:if test="@unique and @unique='true'">
			<xsl:text> unique=</xsl:text>
			<xsl:value-of select="@unique and @unique='true'"/>
		</xsl:if>
		<xsl:if test="@unique-key">			
			<xsl:variable name="unique-key" select="@unique-key"/>
			<xsl:text> unique-key=true</xsl:text>
			<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
			<xsl:text> unique-key-relation=</xsl:text>
			
			<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and field/@name!=$name] | //pojo/class/attribute[@unique-key=$unique-key and field/@name!=$name]">
				<xsl:value-of select="field/@name"/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	<xsl:if test="name()= 'association'">
	 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade <xsl:value-of select="@cascade-name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	 *<xsl:text> </xsl:text>
		 <!-- type de relation -->
		<xsl:if test="@type = 'many-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'many-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<!-- objet cible -->
		<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> targetEntity=</xsl:text>
		<xsl:value-of select="interface/name"/>
		<!-- obligatoire -->
		<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@optional != 'true'"/>
		</xsl:if>
		<!-- proprietaire de la relation -->
		<xsl:text> relationOwner=</xsl:text>
		<xsl:value-of select="@relation-owner"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	 *
	 * @return <xsl:if test="not(@contained-type-short-name)">une entité <xsl:value-of select="@type-short-name"/></xsl:if>
	 			<xsl:if test="@contained-type-short-name">une liste d'entité <xsl:value-of select="@contained-type-short-name"/></xsl:if>
			<xsl:text> correspondant à la valeur de </xsl:text>
			<xsl:if test="name()= 'attribute'"><xsl:text>l'attribut </xsl:text></xsl:if>
			<xsl:if test="name()= 'association'"><xsl:text>l'association </xsl:text></xsl:if>
			<xsl:value-of select="@name"/>
	 */
	<xsl:if test="count(annotations/annotation[@name='Public']) > 0">@Public
	</xsl:if>
	<xsl:text>public </xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text><xsl:value-of select="get-accessor"/>() ;

	/**<xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>
	 * <xsl:value-of select="documentation/doc-setter"/>
	 *
	 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 	 *<xsl:text> </xsl:text>
 	 	<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> type=</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> mandatory=</xsl:text>
		<xsl:value-of select="@nullable = 'false'"/>
		<xsl:if test="@unique and @unique='true'">
			<xsl:text> unique=</xsl:text>
			<xsl:value-of select="@unique and @unique='true'"/>
		</xsl:if>
		<xsl:if test="@unique-key">			
			<xsl:variable name="unique-key" select="@unique-key"/>
			<xsl:text> unique-key=true</xsl:text>
			<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
			<xsl:text> unique-key-relation=</xsl:text>
			
			<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and field/@name!=$name] | //pojo/class/attribute[@unique-key=$unique-key and field/@name!=$name]">
				<xsl:value-of select="field/@name"/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	<xsl:if test="name()= 'association'">
	 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade <xsl:value-of select="@cascade-name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	 *<xsl:text> </xsl:text>
		 <!-- type de relation -->
		<xsl:if test="@type = 'many-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'many-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<!-- objet cible -->
		<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> targetEntity=</xsl:text>
		<xsl:value-of select="interface/name"/>
		<!-- obligatoire -->
		<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@optional != 'true'"/>
		</xsl:if>
		<!-- proprietaire de la relation -->
		<xsl:text> relationOwner=</xsl:text>
		<xsl:value-of select="@relation-owner"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	 *
	 * @param <xsl:value-of select="parameter-name"/><xsl:text> la valeur à affecter à </xsl:text>
			<xsl:if test="name()= 'attribute'"><xsl:text>l'attribut </xsl:text></xsl:if>
			<xsl:if test="name()= 'association'"><xsl:text>l'association </xsl:text></xsl:if>
			<xsl:value-of select="@name"/>
	 *
	 */
	<xsl:if test="count(annotations/annotation[@name='Public']) > 0">
		<xsl:text>@Public
	</xsl:text>
	</xsl:if>
	<xsl:text>public void </xsl:text>
	<xsl:value-of select="set-accessor"/>( <xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of  select="parameter-name"/> ) ;
	</xsl:for-each>
	
	<!-- Méthodes de clonage -->

	/**
	 * {@inheritDoc}
	 */
	@Public	 
	public <xsl:value-of select="//pojo/class/implements/interface/@full-name"/> clone() throws CloneNotSupportedException ;
	
	/**
	 * {@inheritDoc}
	 */
	@Public	 
	public <xsl:value-of select="//pojo/class/implements/interface/@full-name"/> clone(CascadeSet p_oCascadeSet) throws CloneException ;
	
	/**
	 * {@inheritDoc}
	 */
	@Public	 
	public <xsl:value-of select="//pojo/class/implements/interface/@full-name"/> clone(CascadeSet p_oCascadeSet, CloneSession p_oCloneSession) throws CloneException;
	
	/**
	 * Merge les modifications sur l'objet passé en paramètre
	 * 
	 * @param  p_o<xsl:value-of select="//pojo/class/implements/interface/@name"/> object avec lequel il faut faire le merge
	 *
	 * @throws MergeException déclenchée si une erreur de merge survient
	 *
	 * com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#privateMergeWith(com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MEntity)
	 */
	public void mergeWith(<xsl:value-of select="//pojo/class/implements/interface/@name"/> p_o<xsl:value-of select="//pojo/class/implements/interface/@name"/>) throws MergeException ;
	
	/**
	 * Merge avec l'objet passé en paramètre
	 *
	 * @param <xsl:text>p_o</xsl:text><xsl:value-of select="//pojo/class/implements/interface/@name"/> object avec lequel il faut faire le merge
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 *
	 * @throws MergeException déclenchée si une erreur de merge survient
	 */
	public void mergeWith(<xsl:value-of select="//pojo/class/implements/interface/@name"/>
		<xsl:text> p_o</xsl:text><xsl:value-of select="//pojo/class/implements/interface/@name"/>, CascadeSet p_oCascadeSet) throws MergeException ;
	
	<!-- LoadMethod -->
	
	<xsl:if test="count(//pojo/class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
	
	/**
	 * Modifie la méthode de chargement de l'entité traitée
	 *
	 * @param p_oLoadMethod Nouvelle méthode de chargement de l'objet
	 */
	@Public	 
	public void setLoadMethod(LoadMethod&lt;<xsl:value-of select="/pojo/interface/name"/>&gt; p_oLoadMethod);
	
	</xsl:if>
	
</xsl:template>

<xsl:template match="method-signature">
	/** 
	 * <xsl:value-of select="documentation"/>
	 * <xsl:for-each select="javadoc">
 	 * <xsl:value-of select="."/>
	</xsl:for-each>
	 */
	public <xsl:value-of select="return-type/@short-name"/>
	<xsl:if test="return-type/@contained-type-name">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="return-type/@contained-type-short-name"/>
	<xsl:text>&gt;</xsl:text>
	</xsl:if>
<xsl:text> </xsl:text>	
<xsl:value-of select="@name"/>
<xsl:text>(</xsl:text><xsl:if test="count(method-parameter) != 0">
<xsl:for-each select="method-parameter">
<xsl:value-of select="@type-short-name"/>
<xsl:if test="@contained-type-name">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="@contained-type-short-name"/>
	<xsl:text>&gt;</xsl:text>
</xsl:if>
<xsl:text> </xsl:text>
<xsl:value-of select="@name"/>	
</xsl:for-each>
</xsl:if><xsl:text>);
</xsl:text>
</xsl:template>
	
</xsl:stylesheet>