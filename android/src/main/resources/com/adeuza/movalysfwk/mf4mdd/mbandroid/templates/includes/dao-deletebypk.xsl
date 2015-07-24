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

<xsl:template match="dao-interface" mode="delete-by-pk">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Supprime de la base de données l'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * La cascade est this.getDeleteCascade()
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void delete<xsl:value-of select="$interface/name"/>( <xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>
			<xsl:text>, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Supprime de la base de données l'entité <xsl:value-of select="$interface/name"/> passée en paramètre.
	 * La cascade doît être correctement indiquée.
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void delete<xsl:value-of select="$interface/name"/>( <xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Supprime de la base de données l'entité <xsl:value-of select="$interface/name"/> correspondant aux paramètres.
	 * Cette suppression ne supprime pas les entités liés en cascade.
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void delete</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>MContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>



<xsl:template match="dao" mode="delete-by-pk">
	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>

	<!-- Méthode avec l'objet à supprimer en paramètre -->
	/**
	 * Supprime l'entité <xsl:value-of select="interface/name"/> passée en paramètre de la base de données.
	 * La cascade est this.getDeleteCascade()
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void delete<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, MContext p_oContext ) throws DaoException {</xsl:text>
		this.delete<xsl:value-of select="interface/name"/>( p_o<xsl:value-of select="interface/name"/><xsl:text>, this.getDeleteCascade(), p_oContext );</xsl:text>
	}	
	
	/**
	 * Supprime l'entité <xsl:value-of select="interface/name"/> passée en paramètre de la base de données.
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void delete<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {
		</xsl:text>
				
		<xsl:call-template name="cascadedelete-before">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="class" select="class"/>
			<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>

		SqlDelete oSqlDelete = getDeleteQuery();
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="dao-delete-addequalscondition-withvalue">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
				<xsl:with-param name="fields" select="$pkFields"/>
				<xsl:with-param name="queryObject">oSqlDelete</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	
		AndroidSQLiteConnection oConnection = ((MContextImpl) p_oContext).getConnection();
		AndroidSQLitePreparedStatement oStatement = oConnection.prepareStatement(oSqlDelete.toSql(p_oContext));
		try {
			oSqlDelete.bindValues(oStatement);
			oStatement.executeUpdate();
		}
		finally {
			oStatement.close();
		}
		<xsl:call-template name="cascadedelete-after">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="class" select="class"/>
			<xsl:with-param name="object">p_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>
	}

	<!--  Méthode avec l'id de l'objet à supprimer en paramètre -->
	/**
	 * Supprime l'entité <xsl:value-of select="interface/name"/> correspondant aux paramètres de la base de données.
	 * Cette suppression ne supprime pas les entités liés en cascade.
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void delete</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(</xsl:text> 
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>MContext p_oContext ) throws DaoException {
		</xsl:text>
				
		SqlDelete oSqlDelete = getDeleteQuery();
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="dao-delete-addequalscondition-withvalue">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="value"><xsl:value-of select="parameter-name"/></xsl:with-param>
				<xsl:with-param name="fields" select="$pkFields"/>
				<xsl:with-param name="queryObject">oSqlDelete</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		AndroidSQLiteConnection oConnection = ((MContextImpl) p_oContext).getConnection();
		AndroidSQLitePreparedStatement oStatement = oConnection.prepareStatement(oSqlDelete.toSql(p_oContext));
		try {
			oSqlDelete.bindValues(oStatement);
			oStatement.executeUpdate();
		}
		finally {
			oStatement.close();
		}
	}
</xsl:template>
</xsl:stylesheet>
