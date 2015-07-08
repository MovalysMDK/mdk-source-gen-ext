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

	<xsl:include href="includes/class.xsl"/>
	<xsl:include href="includes/pojo/attribute-declaration.xsl"/>
	<xsl:include href="includes/pojo/constructor.xsl"/>
	<xsl:include href="includes/pojo/getter-setter.xsl"/>
	<xsl:include href="includes/pojo/idtostring.xsl"/>

	<xsl:template match="/">
		<xsl:apply-templates select="class" mode="declare-class"/>
	</xsl:template>

	<xsl:template match="class" mode="declare-extra-imports">
		<xsl:choose>
			<xsl:when test="customizable='true'">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.customizable.AbstractCustomizableEntity</import>
			</xsl:when>
			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.AbstractEntity</import>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="class" mode="class-annotations"/>

	<xsl:template match="class" mode="superclass">
		<xsl:text>AbstractEntity&lt;</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="class[customizable='true']" mode="superclass">
		<xsl:text>AbstractCustomizableEntity&lt;</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="class" mode="interfaces">
		<xsl:apply-templates select="implements/interface" mode="declare-interface"/>
	</xsl:template>

	<xsl:template match="class" mode="attributes">
		<xsl:apply-templates select="." mode="attribute-declaration"/>
	</xsl:template>
	
	<xsl:template match="class" mode="constructors">
		<xsl:apply-templates select="." mode="constructor"/>
	</xsl:template>

	<xsl:template match="class" mode="methods">
		<xsl:apply-templates select="." mode="getter-setter"/>
		<xsl:apply-templates select="." mode="idtostring"/>
		<xsl:apply-templates select="implements/interface/linked-interfaces/linked-interface[name = 'AdmableEntity']"/>
	</xsl:template>

	<!--
		Méthodes des objets implémentants l'interface AdmableEntity et qui n'apparaissent pas dans le modèle. 
	 -->
	<xsl:template match="linked-interface[name = 'AdmableEntity']">
		/**
		 * Returns &lt;code&gt;true&lt;/code&gt; if the current object is living. &lt;code&gt;false&lt;/code&gt; otherwise.
		 * @return &lt;code&gt;true&lt;/code&gt; if the current object is living. &lt;code&gt;false&lt;/code&gt; otherwise.
		 */
		@Override
		public boolean isLiving() {
			return MLiving.LIVING.equals(this.admLivingRecord);
		}

		/**
		 * Returns &lt;code&gt;true&lt;/code&gt; if the current object is dead. &lt;code&gt;false&lt;/code&gt; otherwise.
		 * @return &lt;code&gt;true&lt;/code&gt; if the current object is dead. &lt;code&gt;false&lt;/code&gt; otherwise.
		 */
		@Override
		public boolean isDead() {
			return MLiving.DEAD.equals(this.admLivingRecord);
		}
	</xsl:template>
	
	<xsl:template name="mappedBy">
		<xsl:if test="@relation-owner='false'">
			<xsl:text>,mappedBy="</xsl:text>
			<xsl:value-of select="@mapped-by"/>
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
