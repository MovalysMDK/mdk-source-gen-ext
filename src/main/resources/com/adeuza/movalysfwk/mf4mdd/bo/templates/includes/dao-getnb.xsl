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

<xsl:template name="dao-getnb-interface">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="$interface/name"/> en base.
	 *
	 * Les blocs par défaut sont utilisés
	 *
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/> en base
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public int getNb<xsl:value-of select="$interface/name"/><xsl:text>(ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>	
	
	/**
	 * Retourne le nombre d'entité <xsl:value-of select="$interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/>
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public int getNb<xsl:value-of select="$interface/name"/><xsl:text>(DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>
</xsl:template>

<xsl:template name="dao-getnb">

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="interface/name"/> en base.
	 *
	 * Les blocs par défaut sont utilisés
	 *
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="interface/name"/>
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public int getNb<xsl:value-of select="interface/name"/><xsl:text>(ItfTransactionalContext p_oContext) throws DaoException {</xsl:text>
		return this.getNb<xsl:value-of select="interface/name"/><xsl:text>( getCountDaoQuery(), p_oContext);</xsl:text>
	}

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="interface/name"/>
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public int getNb<xsl:value-of select="interface/name"/><xsl:text>(DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext) throws DaoException {</xsl:text>
		return this.getNb(p_oDaoQuery,p_oContext);
	}

</xsl:template>

</xsl:stylesheet>