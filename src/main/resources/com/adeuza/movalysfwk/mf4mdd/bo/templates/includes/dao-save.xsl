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

<xsl:template name="dao-save">

	<xsl:variable name="interface" select="interface"/>

	/**
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	protected void save<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException {
		</xsl:text>
				
		try {
			<xsl:call-template name="cascadesaveupdate-before">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
			</xsl:call-template>
		
			if(!p_oContext.getMessages().hasErrors()) {
				SqlInsert oSqlInsert = this.getInsertQuery();
				Connection oConnection = ((ContextImpl)p_oContext).getTransaction().getJDBCConnection();
				<xsl:if test="class/identifier/attribute/field/sequence">PreparedStatement oStatement = oConnection.prepareStatement( oSqlInsert.toSql(p_oContext), GENERATED_COLUMNS);</xsl:if>
				<xsl:if test="not(class/identifier/attribute/field/sequence)">PreparedStatement oStatement = oConnection.prepareStatement( oSqlInsert.toSql(p_oContext));</xsl:if>
				try {
					bindInsert( p_o<xsl:value-of select="interface/name"/>, oStatement, p_oContext );
					oStatement.executeUpdate();
					<xsl:if test="class/identifier/attribute/field/sequence">
					ResultSetReader oResultSetReader = new ResultSetReader(oStatement.getGeneratedKeys());
					try {
						if ( oResultSetReader.next()) {
							<xsl:for-each select="class/identifier/attribute/field/sequence">
								<xsl:call-template name="jdbc-retrieve-key">
									<xsl:with-param name="interface" select="$interface"/>
									<xsl:with-param name="prefix">p_o</xsl:with-param>
									<xsl:with-param name="resultSet">oResultSetReader</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						}
					} finally {
						oResultSetReader.close();
					}</xsl:if>
				} finally {
					oStatement.close();
				}
			}
			<xsl:call-template name="cascadesaveupdate-after">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
			</xsl:call-template>
		} catch( SQLException e ) {
			throw new DaoException(e);
		}
	}
</xsl:template>

</xsl:stylesheet>
