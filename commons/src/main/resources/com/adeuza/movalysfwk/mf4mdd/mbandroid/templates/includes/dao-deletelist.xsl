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

<xsl:template match="dao-interface" mode="delete-list">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Supprime de la base de données la liste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * La cascade est CascadeSet.NONE
	 * @param p_list<xsl:value-of select="$interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void deleteList<xsl:value-of select="$interface/name"/>( Collection&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Supprime de la base de données la liste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * @param p_list<xsl:value-of select="$interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void deleteList<xsl:value-of select="$interface/name"/>( Collection&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>



<xsl:template match="dao" mode="delete-list">
	<xsl:variable name="interface" select="interface"/>

	/**
	 * Supprime de la base de données la liste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * La cascade est CascadeSet.NONE
	 * @param p_list<xsl:value-of select="interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void deleteList<xsl:value-of select="interface/name"/>( Collection&lt;<xsl:value-of select="interface/name"/>&gt; p_list<xsl:value-of select="interface/name"/>
			<xsl:text>, MContext p_oContext ) throws DaoException {</xsl:text>
			this.deleteList<xsl:value-of select="interface/name"/>( p_list<xsl:value-of select="interface/name"/><xsl:text>, CascadeSet.NONE, p_oContext );</xsl:text>
	}

	/**
	 * Supprime de la base de données la liste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * @param p_list<xsl:value-of select="interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void deleteList<xsl:value-of select="interface/name"/>( Collection&lt;<xsl:value-of select="interface/name"/>&gt; p_list<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {
		</xsl:text>
		if(!p_list<xsl:value-of select="interface/name"/>.isEmpty()){
			try {
			
				<xsl:call-template name="cascadedelete-before">
					<xsl:with-param name="interface" select="interface"/>
					<xsl:with-param name="class" select="class"/>
					<xsl:with-param name="object">p_list<xsl:value-of select="interface/name"/></xsl:with-param>
					<xsl:with-param name="traitement-list">true</xsl:with-param>
				</xsl:call-template>
			
				<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
				SqlDelete oSqlDelete = getDeleteQuery();
				<xsl:for-each select="class/identifier/descendant::attribute">
					<xsl:call-template name="dao-sql-addequalscondition-withoutvalue">
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
						<xsl:with-param name="fields" select="$pkFields"/>
						<xsl:with-param name="queryObject">oSqlDelete</xsl:with-param>
						<xsl:with-param name="returnObject">oSqlEqualsValueCondition<xsl:value-of select="position()"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			
				Connection oConnection = ((MContextImpl)p_oContext).getTransaction().getConnection();
				PreparedStatement oStatement = oConnection.prepareStatement(oSqlDelete.toSql(p_oContext));
				try {
					for(<xsl:value-of select="interface/name"/>
					<xsl:text> o</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> : p_list</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text> ) { </xsl:text>
					
						<xsl:for-each select="class/identifier/descendant::attribute">
							<xsl:call-template name="dao-sql-setequalsconditionvalue">
								<xsl:with-param name="interface" select="$interface"/>
								<xsl:with-param name="object">o<xsl:value-of select="$interface/name"/></xsl:with-param>
								<xsl:with-param name="fields" select="$pkFields"/>
								<xsl:with-param name="conditionObject">oSqlEqualsValueCondition<xsl:value-of select="position()"/></xsl:with-param>	
							</xsl:call-template>
						</xsl:for-each>
						
						oSqlDelete.bindValues(oStatement);
						oStatement.addBatch();
					}
				
					oStatement.executeBatch();
				} finally {
					oStatement.close();
				}
				<xsl:call-template name="cascadedelete-after">
					<xsl:with-param name="interface" select="interface"/>
					<xsl:with-param name="class" select="class"/>
					<xsl:with-param name="object">p_list<xsl:value-of select="interface/name"/></xsl:with-param>
					<xsl:with-param name="traitement-list">true</xsl:with-param>
				</xsl:call-template>
			}
			catch( SQLException e ) {
				throw new DaoException(e);
			}
		}
	}
	
</xsl:template>

</xsl:stylesheet>
