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

<!-- Traite les champs de la clé primaire ( premiere passe : sans traiter les cascades sur la clé primaire ) -->
<xsl:template name="jdbc-retrieve-pk-firstpass">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	<xsl:param name="resultSet"/>

	<!-- si attribute de la classe -->
	<xsl:if test="parent::identifier">
		<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="set-accessor"/>
			<xsl:text>(</xsl:text>
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text">
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text"><xsl:value-of select="jdbc-retrieve"/></xsl:with-param>
						<xsl:with-param name="from">POSITION</xsl:with-param>
						<xsl:with-param name="to"><xsl:value-of select="@pos"/></xsl:with-param>						
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="from">RESULTSET</xsl:with-param>
				<xsl:with-param name="to" select="$resultSet"/>
			</xsl:call-template><xsl:text>);
		</xsl:text>	
	</xsl:if>
	
	<!-- si attribute d'association -->
	<xsl:if test="parent::association">

		<xsl:variable name="associationNameWithUpper"><xsl:text>o</xsl:text><xsl:call-template name="first-letter-to-uppercase"><xsl:with-param name="text"><xsl:value-of select="../@name"/></xsl:with-param></xsl:call-template></xsl:variable>

		<!-- si premier attribute de l'asso, on instancie l'objet correspondant à l'asso -->
		<xsl:if test="count(preceding-sibling::attribute) = 0 ">

			<xsl:value-of select="../interface/name"/><xsl:text> </xsl:text><xsl:value-of select="$associationNameWithUpper"/>
				<xsl:text> = this.</xsl:text><xsl:value-of select="../pojo-factory-interface/bean-name"/>.createInstanceNoChangeRecord();
		</xsl:if>
		
		<!-- valuation de l'attribut avec le resultset -->
				<xsl:value-of select="$associationNameWithUpper"/>
				<xsl:text>.</xsl:text><xsl:value-of select="set-accessor"/><xsl:text>(</xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text">
						<xsl:call-template name="replace-string">
							<xsl:with-param name="text"><xsl:value-of select="jdbc-retrieve"/></xsl:with-param>
							<xsl:with-param name="from">POSITION</xsl:with-param>
							<xsl:with-param name="to"><xsl:value-of select="@pos"/></xsl:with-param>						
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="from">RESULTSET</xsl:with-param>
					<xsl:with-param name="to" select="$resultSet"/>
				</xsl:call-template><xsl:text>);
		</xsl:text>
		
		<!--  Si dernier attribut d'association, on l'affecte l'association à l'objet principal -->
		<xsl:if test="count(following-sibling::attribute) = 0 ">
			<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="../set-accessor"/>
			<xsl:text>(</xsl:text><xsl:value-of select="$associationNameWithUpper"/>);
		</xsl:if>
		
	</xsl:if>
	
</xsl:template>

</xsl:stylesheet>