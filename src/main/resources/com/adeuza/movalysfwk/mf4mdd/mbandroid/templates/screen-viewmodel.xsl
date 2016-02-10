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

	<xsl:include href="includes/class.xsl"/>

	<xsl:output method="text"/>

	<!-- MAIN TEMPLATE .............................................................................................. -->

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="viewmodel" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractViewModel</import>
		<xsl:apply-templates select="./subvm/viewmodel/import[1]" mode="declare-import"/>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	<xsl:template match="viewmodel" mode="superclass">
		<xsl:text>AbstractViewModel</xsl:text>
	</xsl:template>

	<!-- ATTRIBUTES ................................................................................................. -->

	<xsl:template match="viewmodel" mode="attributes">
		<xsl:apply-templates select="identifier/attribute[not(@name='id_id') and not(@name='id_identifier')]" mode="declare-attribute"/>
		<xsl:apply-templates select="attribute" mode="declare-attribute"/>
		<xsl:for-each select="./subvm/viewmodel">
		private <xsl:if test="string-length(./type/list)>0"><xsl:value-of select="./type/list"/>&lt;</xsl:if>
		<xsl:if test="./type/name='LIST_3' or ./type/name='LIST_1__ONE_SELECTED'">
			<xsl:value-of select="./entity-to-update/name"/>
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:value-of select="substring(./name,0,string-length(./name)-3)"/>

		<xsl:if test="string-length(./type/list)>0">&gt; lst</xsl:if>
		<xsl:if test="string-length(./type/list)=0"> o</xsl:if>
		<xsl:value-of select="./name"/> = null;

		<!-- Un élément sélectionnable sur la liste. Déclaration de l'élément sélectionné -->
		<xsl:if test="./type/name='LIST_1__ONE_SELECTED'">
		private <xsl:value-of select="substring(./name,0,string-length(./name)-3)"/> selected<xsl:value-of select="./name"/> = null;
		</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="attribute" name="declare-attribute">
		/**
		 * <xsl:value-of select="documentation/doc-attribute"/>
		 * <xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>
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
		*/<xsl:variable name="attribute" select="concat('attribute-', @name)"/>
		//@non-generated-start[attribute-<xsl:value-of select="@name"/>]
			<xsl:value-of select="/class/non-generated/bloc[@id=$attribute]"/>
			<xsl:text>//@non-generated-end[attribute-</xsl:text><xsl:value-of select="@name"/>]
		<xsl:value-of select="@visibility"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@type-short-name"/>
			<xsl:if test="@contained-type-short-name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="@contained-type-short-name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/> ;
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="viewmodel" mode="methods">
		<xsl:apply-templates select="./identifier/attribute[not(@name='id_id') and not(@name='id_identifier')]" mode="declare-getset"/>
		<xsl:apply-templates select="./attribute" mode="declare-getset"/>
		<xsl:for-each select="./subvm/viewmodel">
		/** 
		 * {@inheritDoc}
		 */
		@Override
		public <xsl:if test="string-length(./type/list)>0"><xsl:value-of select="./type/list"/>&lt;</xsl:if>
		<xsl:if test="./type/name='LIST_3' or ./type/name='LIST_1__ONE_SELECTED'"><xsl:value-of select="./entity-to-update/name"/>,</xsl:if>
		<xsl:value-of select="substring(./name,0,string-length(./name)-3)"/><xsl:if test="string-length(./type/list)>0">&gt;</xsl:if> get<xsl:if test="string-length(./type/list)>0">Lst</xsl:if><xsl:value-of select="substring(./name,0,string-length(./name)-3)"/>() {
			return this.<xsl:if test="string-length(./type/list)>0">lst</xsl:if><xsl:if test="string-length(./type/list)=0">o</xsl:if><xsl:value-of select="./name"/>;
		}
		
		/** 
		 * {@inheritDoc}
		 */
		@Override
		public void set<xsl:if test="string-length(./type/list)>0">Lst</xsl:if><xsl:value-of select="substring(./name,0,string-length(./name)-3)"/>(<xsl:if test="string-length(./type/list)>0"><xsl:value-of select="./type/list"/>&lt;
		<xsl:if test="./type/name='LIST_3' or ./type/name='LIST_1__ONE_SELECTED'"><xsl:value-of select="./entity-to-update/name"/>,</xsl:if>
		</xsl:if><xsl:value-of select="substring(./name,0,string-length(./name)-3)"/><xsl:if test="string-length(./type/list)>0">&gt;</xsl:if> p_oData) {
			this.<xsl:if test="string-length(./type/list)>0">lst</xsl:if><xsl:if test="string-length(./type/list)=0">o</xsl:if><xsl:value-of select="./name"/> = p_oData;
		}
		</xsl:for-each>
		
		<xsl:if test="./attribute/@type-short-name!='List'">
			/** 
			 * {@inheritDoc}
			 */
			@Override	
			public String getIdVM() {
				return String.valueOf(this.<xsl:value-of select="./identifier/attribute/get-accessor"/>());
			}
		</xsl:if>
	</xsl:template>

	<xsl:template match="attribute" mode="declare-getset">
		/** 
		 * {@inheritDoc}
		 */
		@Override
		public<xsl:text> </xsl:text>
						<xsl:value-of select="@type-short-name"/>
			<xsl:if test="@contained-type-short-name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="@contained-type-short-name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text><xsl:value-of select="get-accessor"/>() {
			return this.<xsl:value-of select="@name"/> ;
		}

		/** 
		 * {@inheritDoc}
		 */
		@Override
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="set-accessor"/>( <xsl:value-of select="@type-short-name"/>
			<xsl:if test="@contained-type-short-name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="@contained-type-short-name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of  select="parameter-name"/> ) {
			this.<xsl:value-of select="@name"/> = <xsl:value-of select="parameter-name"/>;
		}
	</xsl:template>
</xsl:stylesheet>
