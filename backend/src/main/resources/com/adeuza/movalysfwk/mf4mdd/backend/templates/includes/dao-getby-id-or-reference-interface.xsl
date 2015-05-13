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

<xsl:template name="dao-interface-getby-id-or-reference">
	<xsl:param name="interface" select="dao/interface"/>
	<xsl:param name="classe" select="dao/class"/>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>
	
	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */ 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @return une entité <xsl:value-of select="$interface/name"/> en utilisant la clé primaire ou la référence externe
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$interface/name"/><xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException;</xsl:text>
</xsl:template>

</xsl:stylesheet>