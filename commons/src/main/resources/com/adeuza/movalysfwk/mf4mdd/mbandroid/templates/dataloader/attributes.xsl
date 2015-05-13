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

	<xsl:output method="text" />
	
	<!--
		Attribute generation
	-->
	<xsl:template match="dataloader-impl" mode="attributes">
		<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">loadCascade</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>/**&#13;</xsl:text>
					<xsl:text>* Load cascade&#13;</xsl:text>
					<xsl:text>**/&#13;</xsl:text>
					<xsl:text>private static final CascadeSet LOAD_CASCADE = </xsl:text>
					<xsl:if test="count(cascades/cascade) != 0">
						<xsl:text>CascadeSet.of(</xsl:text>
						<xsl:for-each select="cascades/cascade">
							<xsl:value-of select="name"/>
							<xsl:if test="position() != last()">
								<xsl:text>,</xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:if test="count(cascades/cascade) = 0">
						<xsl:text>CascadeSet.NONE</xsl:text>
					</xsl:if>
					<xsl:text>;&#13;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:text>&#13;</xsl:text>

			<xsl:for-each select="dataloader-interface/combos/combo">
				<xsl:choose>
					<xsl:when test="cascades">
									
						<xsl:text>private static final CascadeSet </xsl:text>
						<xsl:value-of select="entity-attribute-name"/>
						<xsl:text>Cascade = CascadeSet.of(</xsl:text>
						<xsl:for-each select="cascades/cascade">
							<xsl:value-of select="name"/>
							<xsl:if test="position() != last()">
								<xsl:text>,</xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>);&#13;&#13;</xsl:text>
						
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="dataloader-interface/entity-type/transient = 'true' and dataloader-interface/entity-type/scope = 'APPLICATION'">
			<xsl:text>/** DataLoader attribute for an &lt;code&gt;</xsl:text>
			<xsl:value-of select="dataloader-interface/entity-type/name"/>
			<xsl:text>&lt;/code&gt; object */&#13;</xsl:text>
			<xsl:text>private </xsl:text>
			<xsl:value-of select="dataloader-interface/entity-type/name"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="dataloader-interface/entity-type/attribute-name"/>
			<xsl:text> = null;&#13;</xsl:text>
		</xsl:if>

		<xsl:for-each select="dataloader-interface/combos/combo">
			/** attribute for <xsl:value-of select="entity"/> combo values */
			<xsl:text>private List&lt;</xsl:text>
			<xsl:value-of select="entity"/>
			<xsl:text>&gt; </xsl:text>
			<xsl:value-of select="entity-attribute-name"/>
			<xsl:text> = null;&#13;&#13;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
