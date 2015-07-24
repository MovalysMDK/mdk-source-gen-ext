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

<xsl:template match="method-signature[@type='getNbEntite']">
	<xsl:param name="interface" select="../interface"/>
	<xsl:param name="classe" select="../class"/>

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="$interface/name"/> selon les paramètres.
	 * Les blocs par défaut sont utilisés
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/>
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text><xsl:value-of select="return-type/@short-name"/><xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>MContext p_oContext ) throws DaoException {</xsl:text>
	return this.<xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>getCountDaoQuery(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="$interface/name"/> selon les paramètres.
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/>
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text><xsl:value-of select="return-type/@short-name"/><xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, MContext p_oContext ) throws DaoException {
		</xsl:text>
		return 0;
	}
</xsl:template>

</xsl:stylesheet>
