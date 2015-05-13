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

<xsl:template match="dao" mode="updatelist">

	<xsl:variable name="interface" select="interface"/>

	/**
	 * Updates the given list of entities in the database
	 * @param p_list<xsl:value-of select="interface/name"/> une liste d'entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession dao session	 
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void updateList<xsl:value-of select="interface/name"/>( Collection&lt;<xsl:value-of select="interface/name"/>&gt; p_list<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		</xsl:text>
		
		try {
			<xsl:variable name="listToUpdate">list<xsl:value-of select="interface/name"/>ToUpdate</xsl:variable>
		 	Collection&lt;<xsl:value-of select="interface/name"/>&gt; <xsl:value-of select="$listToUpdate"/> = p_oDaoSession.getEntitiesToPersist(
		 		<xsl:value-of select="interface/name"/>.ENTITY_NAME, p_list<xsl:value-of select="interface/name"/>, true );
		
			<xsl:call-template name="cascadesaveupdate-before">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object"><xsl:value-of select="$listToUpdate"/></xsl:with-param>
				<xsl:with-param name="traitement-list">true</xsl:with-param>
			</xsl:call-template>
		
			if(!p_oContext.getMessages().hasErrors()) {
				<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
			
				SqlUpdate oSqlUpdate = this.getUpdateQuery();
				<xsl:for-each select="class/identifier/descendant::attribute">
					<xsl:call-template name="dao-sql-addequalscondition-withoutvalue">
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="fields" select="$pkFields"/>
						<xsl:with-param name="queryObject">oSqlUpdate</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				Connection oConnection = ((MContextImpl)p_oContext).getTransaction().getConnection();
				PreparedStatement oStatement = oConnection.prepareStatement(oSqlUpdate.toSql(p_oContext));
				try {
					for( <xsl:value-of select="interface/name"/>
					<xsl:text> o</xsl:text><xsl:value-of select="interface/name"/>
					<xsl:text> : </xsl:text>
					<xsl:value-of select="$listToUpdate"/>
					<xsl:text> ) { </xsl:text>
					bindUpdate( o<xsl:value-of select="interface/name"/>, oStatement, p_oContext );
					oStatement.addBatch();
					}
					oStatement.executeBatch();
					
					<xsl:if test="class/parameters/parameter[@name='oldidholder'] = 'true'">
						for( <xsl:value-of select="interface/name"/>
							<xsl:text> o</xsl:text><xsl:value-of select="interface/name"/>
							<xsl:text> : </xsl:text>
							<xsl:value-of select="$listToUpdate"/>
							<xsl:text> ) { </xsl:text>
							o<xsl:value-of select="interface/name"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="class/attribute[parameters/parameter[@name='oldidholder'] = 'true']/set-accessor"/>
							<xsl:text>( o</xsl:text>
							<xsl:value-of select="interface/name"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="class/identifier/attribute/get-accessor"/>
							<xsl:text>());</xsl:text>
						}
					</xsl:if>
					
				} finally {
					oStatement.close();
				}
			}
			
			<xsl:call-template name="cascadeupdate-after">
				<xsl:with-param name="interface" select="interface"/>
				<xsl:with-param name="class" select="class"/>
				<xsl:with-param name="object"><xsl:value-of select="$listToUpdate"/></xsl:with-param>
				<xsl:with-param name="traitement-list">true</xsl:with-param>
			</xsl:call-template>
			
		} catch( SQLException e ) {
			throw new DaoException(e);
		}
	}
	
</xsl:template>

</xsl:stylesheet>
