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
	 *
	 * Les blocs par défaut sont utilisés
	 *
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/>
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text><xsl:value-of select="return-type/@short-name"/><xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
	return this.<xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>getCountDaoQuery(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne le nombre d'entité <xsl:value-of select="$interface/name"/> selon les paramètres.
	 *
	 * <xsl:value-of select="./documentation"/>
	 * <xsl:for-each select="method-parameter">
	 * @param <xsl:value-of select="@name"/> un paramètre de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 *
	 * @return le nombre d'entité <xsl:value-of select="$interface/name"/>
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text><xsl:value-of select="return-type/@short-name"/><xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext ) throws DaoException {
		</xsl:text>
		
		int r_iResult = -1;
		try {
			<xsl:call-template name="dao-historisation-method-parameter">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="method-parameter" select="method-parameter"/>
			</xsl:call-template>
			<xsl:text>PreparedStatement oStatement = p_oDaoQuery.prepareStatement(p_oContext);</xsl:text>
			try {
				<xsl:for-each select="descendant::attribute">
					<xsl:call-template name="jdbc-bind-param">
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="statement">oStatement</xsl:with-param>
						<xsl:with-param name="object"><xsl:value-of select="ancestor::method-parameter/@name"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				p_oDaoQuery.bind( oStatement, <xsl:value-of select="count(descendant::attribute) + 1"/>);
				ResultSet oResultSet = oStatement.executeQuery();
				try {
					if(oResultSet.next()){
						r_iResult = oResultSet.getInt(1);
					}
				} finally {
					oResultSet.close();
				}
			} finally {
				oStatement.close();
			}
			<xsl:call-template name="dao-historisation-end"/>
		} catch( SQLException e ) {
			throw new DaoException(e);
		}
		return r_iResult;
	}
</xsl:template>

</xsl:stylesheet>