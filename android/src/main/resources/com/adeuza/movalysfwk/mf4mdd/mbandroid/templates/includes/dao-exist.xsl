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

<xsl:template match="dao" mode="exist">
	<xsl:variable name="interface" select="interface"/>

	<xsl:if test="count(class/identifier/attribute/field/sequence) = 0">
		/**
		 * Returns true if the entity given in parameter exists
		 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
		 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
		 * @param p_oContext contexte transactionnel
		 * @return un boolean indiquant si l'entité existe en base
		 * @throws DaoException déclenchée si une exception technique survient
		 */
		protected boolean exist(<xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>,
				CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {
			boolean r_bExist = false ;
			try {
				DaoQuery oQuery = this.getSelectDaoQuery();
				<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
				<xsl:for-each select="class/identifier/descendant::attribute">
					<xsl:call-template name="dao-sql-addequalscondition-withvalue">
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="queryObject">oQuery.getSqlQuery()</xsl:with-param>
						<xsl:with-param name="fields" select="$pkFields"/>
						<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
<!-- 
				<xsl:call-template name="dao-historisation-identifier-object">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="class" select="class"/>
				</xsl:call-template>
-->
				<xsl:text>PreparedStatement oStatement = oQuery.prepareStatement(p_oContext);</xsl:text>

				try {			
					oQuery.bindValues(oStatement);
					ResultSet oResultSet = oStatement.executeQuery();
					try {
						if ( oResultSet.next()) {
							r_bExist = true;
						}
					} finally {
						oResultSet.close();
					}
				} finally {
					oStatement.close();
				}
			} catch( SQLException e ) {
				throw new DaoException(e);
			}
			return r_bExist ;
		}
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
