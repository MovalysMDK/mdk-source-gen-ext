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

	<xsl:include href="includes/interface.xsl"/>
	<xsl:include href="includes/incremental/nongenerated.xsl"/>

	<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>	

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="pojo">
		<xsl:apply-templates select="interface" mode="declare-interface"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="interface" mode="declare-extra-imports">
		<xsl:if test="../class/@join-class = 'true'"><import>com.adeuza.movalysfwk.mf4jcommons.core.beans.MEntity</import></xsl:if>
	</xsl:template>

	<!-- DOCUMENTATION .............................................................................................. -->

	<xsl:template match="interface" mode="documentation">
		/**
		 * 
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Interface : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 *
		 * <xsl:value-of select="//pojo/class/documentation"/>
		 * 
		 * <xsl:for-each select="//pojo/class/stereotypes/stereotype/documentation">
		 *	<xsl:value-of select="."/>
		 * </xsl:for-each>
		 */
	</xsl:template>

	<!-- SUPERINTERFACES ............................................................................................ -->

	<xsl:template match="interface" mode="superinterfaces">
		<xsl:apply-templates select="./linked-interface" mode="superinterface"/>
		<xsl:if test="../class/@join-class = 'true'">MEntity</xsl:if>
	</xsl:template>

	<!-- CONSTANTS .................................................................................................. -->

	<xsl:template match="interface" mode="constants">
		/**
		 * Constante indiquant le nom de l'entité
		 */
		public static final String ENTITY_NAME = "<xsl:value-of select="//pojo/interface/name"/>";
	</xsl:template>

	<!-- METHODS .................................................................................................. -->

	<!-- Désactiviation de la génération par défaut: documentation modifiée. -->
	<xsl:template match="interface/method-signature" mode="declare-method"/>

	<xsl:template match="interface" mode="methods">
		<xsl:call-template name="create-method-signature"/>

		<xsl:if test="../class/@join-class = 'true'">
			/**
			 * Renvoie l'identifiant de l'attribut <xsl:value-of select="../class/left-association/name-for-join-class"/> au format chaîne de caractères.
			 * 
			 * @return l'identifiant de l'attribut <xsl:value-of select="../class/left-association/name-for-join-class"/> au format chaîne de caractères.
			 */
			public String <xsl:value-of select="../class/left-association/name-for-join-class"/>IdToString();

			/**
			 * Renvoie l'identifiant de l'attribut <xsl:value-of select="../class/right-association/name-for-join-class"/> au format chaîne de caractères.
			 * 
			 * @return l'identifiant de l'attribut <xsl:value-of select="../class/right-association/name-for-join-class"/> au format chaîne de caractères.
			 */
			public String <xsl:value-of select="../class/right-association/name-for-join-class"/>IdToString();
		</xsl:if>
	</xsl:template>

	<xsl:template name="create-method-signature">
		<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
			<xsl:text>/**</xsl:text>
			<xsl:if test="name()= 'attribute'">
				<xsl:variable name="name" select="field/@name"/>
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

				<!-- transient -->
				<xsl:text> transient=</xsl:text>
				<xsl:value-of select="@transient"/>
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
		<!-- transient -->
		<xsl:text> transient=</xsl:text>
		<xsl:value-of select="@transient"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	 *
	 * @param <xsl:value-of select="parameter-name"/><xsl:text> la valeur à affecter à </xsl:text>
			<xsl:if test="name()= 'attribute'"><xsl:text>l'attribut </xsl:text></xsl:if>
			<xsl:if test="name()= 'association'"><xsl:text>l'association </xsl:text></xsl:if>
			<xsl:value-of select="@name"/>
	 *
	 */
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
		<xsl:text>(</xsl:text>
		<xsl:if test="count(method-parameter) != 0">
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
		</xsl:if>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
