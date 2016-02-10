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

<xsl:template match="method-signature[@type='deleteEntite']">
	<xsl:param name="interface" select="../interface"/>
	<xsl:param name="classe" select="../class"/>

	/**
	 * Supprime de la base de données l'entité <xsl:value-of select="$interface/name"/> selon les paramètres.
	 *
	 * La cascade est CascadeSet.NONE
	 *
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text>
			<xsl:value-of select="return-type/@short-name"/>
			<xsl:text> </xsl:text> <xsl:value-of select="@name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Supprime de la base de données l'entité <xsl:value-of select="$interface/name"/> selon les paramètres.
	 *
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text>
			<xsl:value-of select="return-type/@short-name"/>
			<xsl:text> </xsl:text> <xsl:value-of select="@name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

</xsl:stylesheet>