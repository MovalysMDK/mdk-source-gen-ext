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

<xsl:template match="dao" mode="save">

	<xsl:variable name="interface" select="interface"/>

	/**
	 * Saves a <xsl:value-of select="interface/name"/> entity with the cascade sent as parameter
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void save<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		</xsl:text>
				
		if ( !p_oDaoSession.isAlreadySaved(<xsl:value-of select="interface/name"/>.ENTITY_NAME, p_o<xsl:value-of select="interface/name"/>)) {
			p_oDaoSession.markAsSaved(<xsl:value-of select="interface/name"/>.ENTITY_NAME, p_o<xsl:value-of select="interface/name"/>);
		
			<xsl:call-template name="cascadesaveupdate-before">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
			</xsl:call-template>
	
			if(!p_oContext.getMessages().hasErrors()) {
				SqlInsert oSqlInsert = this.getInsertQuery();
				AndroidSQLiteConnection oConnection = ((MContextImpl) p_oContext).getConnection();
				<xsl:if test="class/identifier/attribute/field/sequence">MDKSQLiteStatement oStatement = oConnection.compileStatement( oSqlInsert.toSql(p_oContext), GENERATED_COLUMNS);</xsl:if>
				<xsl:if test="not(class/identifier/attribute/field/sequence)">MDKSQLiteStatement oStatement = oConnection.compileStatement( oSqlInsert.toSql(p_oContext));</xsl:if>
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

					<xsl:if test="class/parameters/parameter[@name='oldidholder'] = 'true'">
						p_o<xsl:value-of select="interface/name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="class/attribute[parameters/parameter[@name='oldidholder'] = 'true']/set-accessor"/>
						<xsl:text>( p_o</xsl:text>
						<xsl:value-of select="interface/name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="class/identifier/attribute/get-accessor"/>
						<xsl:text>());
						</xsl:text>
					</xsl:if>
				} finally {
					oStatement.close();
				}
			}
			<xsl:call-template name="cascadesave-after">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
			</xsl:call-template>
		}
	}
</xsl:template>

</xsl:stylesheet>
