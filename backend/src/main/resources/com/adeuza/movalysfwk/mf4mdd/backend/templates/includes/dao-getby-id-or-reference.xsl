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

<xsl:template name="dao-getby-id-or-reference">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="classe" select="class"/>

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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, this.getSelectDaoQuery(), CascadeSet.NONE, new DaoSession(), p_oContext);
	}

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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, p_oDaoQuery, CascadeSet.NONE, new DaoSession(), p_oContext);
	}

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
	public <xsl:value-of select="$interface/name"/>
		<xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>,  this.getSelectDaoQuery(), p_oCascadeSet, new DaoSession(), p_oContext);
	}

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
	public <xsl:value-of select="$interface/name"/>
		<xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, this.getSelectDaoQuery(), CascadeSet.NONE, p_oDaoSession, p_oContext);
	}
	
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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, p_oDaoQuery, p_oCascadeSet, new DaoSession(), p_oContext);
	}	
	
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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException {
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, p_oDaoQuery, CascadeSet.NONE, p_oDaoSession, p_oContext);
	}

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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> <xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="$interface/name"/>(p_o<xsl:value-of select="$interface/name"/>, this.getSelectDaoQuery(), p_oCascadeSet, p_oDaoSession, p_oContext);
	}
	
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
	public <xsl:value-of select="$interface/name"/><xsl:text> get</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
		<xsl:value-of select="$interface/name"/> <xsl:text> p_o</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>, DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext) throws DaoException {</xsl:text>
		<xsl:value-of select="$interface/name"/> r_o<xsl:value-of select="$interface/name"/> = null ;
		<xsl:call-template name="dao-historisation-getX-single-set-query">
			<xsl:with-param name="interface" select="$interface"/>
		</xsl:call-template>
		<!-- Pour que ca marche, la cle primaire doit etre simple, de type long et s'appeler id -->
		<xsl:if test="count($classe/identifier/attribute) = 1 and $classe/identifier/attribute/@name = 'id' and count($classe/identifier/association) = 0 ">
		if ( p_o<xsl:value-of select="$interface/name"/>.getId() <xsl:text><![CDATA[<]]></xsl:text> 0 ) {
			if ( !p_o<xsl:value-of select="$interface/name"/>.getReferences().isEmpty()) {
				Reference oReference = p_o<xsl:value-of select="$interface/name"/>.getReferences().iterator().next();
				p_oDaoQuery.setQueryExternalSiFilter(oReference.getExtSiId(), oReference.getExtSiEntityId());
				BOList&lt;<xsl:value-of select="$interface/name"/>&gt; r_list<xsl:value-of select="$interface/name"/>
				<xsl:text> = this.getList</xsl:text><xsl:value-of select="$interface/name"/>(p_oDaoQuery, p_oContext );
				if ( !r_list<xsl:value-of select="$interface/name"/>.isEmpty() ) {
					r_o<xsl:value-of select="$interface/name"/> = r_list<xsl:value-of select="$interface/name"/>.get(0);
					r_o<xsl:value-of select="$interface/name"/>.addAllReferences(p_o<xsl:value-of select="$interface/name"/>.getReferences());
				}
			}
		} else {
			r_o<xsl:value-of select="$interface/name"/> = this.get<xsl:value-of select="$interface/name"/>(
				<xsl:for-each select="$classe/identifier/*">
					<xsl:text>p_o</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>(), </xsl:text>
				</xsl:for-each>
				<xsl:text>p_oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext);</xsl:text>
		}
		</xsl:if>
		<xsl:if test="count($classe/identifier/attribute) != 1 or $classe/identifier/attribute/@name != 'id' and count($classe/identifier/association) != 0 ">
			r_o<xsl:value-of select="$interface/name"/> = this.get<xsl:value-of select="$interface/name"/>(
				<xsl:for-each select="class/identifier/descendant::attribute">
					<xsl:text>p_o</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>.</xsl:text>
					<xsl:if test="parent::association">
						<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text>
					</xsl:if>
					<xsl:value-of select="get-accessor"/><xsl:text>(), </xsl:text>
				</xsl:for-each>
				<xsl:text>p_oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext);</xsl:text>
		</xsl:if>
		return r_o<xsl:value-of select="$interface/name"/> ;
	}
	
</xsl:template>

</xsl:stylesheet>