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

<xsl:template name="cascade-getlist-post">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	
	/**
	 * Permet de traiter les cascades pour les méthodes 'getList()'
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	protected void postTraitementCascade(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
	
		List&lt;SqlInValueCondition&gt; listSqlInValueCondition = p_oCascadeOptim.getInClausesForMainEntities();	
	
		<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
		this.postTraitementCascadeManyToOneAndOneToOneRelationOwner(listSqlInValueCondition,p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
	
		<xsl:if test="class/association[@transient = 'false' and (@type='one-to-many' or (@type='one-to-one' and @relation-owner='false'))]">
		this.postTraitementCascadeOneToManyAndOneToOneNotRelationOwner(listSqlInValueCondition,p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		<xsl:if test="class/association[@transient = 'false' and @type='many-to-many']">
		this.postTraitementCascadeManyToMany(listSqlInValueCondition,p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		this.postTraitementCascadeFramework(listSqlInValueCondition,p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);
	
	}
	
	<!-- Gestion des cascades :
		- many-to-one
		- many-to-one et relation owner = true
	 -->
	 	<!-- Gestion des cascades :
		- one-to-many
		- many-to-one et relation owner = false
	-->
	<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
	/**
	 * Permet de traiter les cascades ManyToOne et OneToOne pour les méthodes 'getList()'
	 *
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeManyToOneAndOneToOneRelationOwner(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
	<xsl:call-template name="cascade-getlist-post-many2one-one2oneRelationOwner">
	 	<xsl:with-param name="interface" select="$interface"/>
	 	<xsl:with-param name="class" select="$class"/>
	</xsl:call-template>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
	/**
	 * Permet de traiter les cascades OneToMany et OneToOne pour les méthodes 'getList()'
	 *
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeOneToManyAndOneToOneNotRelationOwner(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
	<xsl:call-template name="cascade-getlist-post-one2many-one2oneNotRelationOwner">
	 	<xsl:with-param name="interface" select="$interface"/>
	 	<xsl:with-param name="class" select="$class"/>
	</xsl:call-template>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@type='many-to-many' and @transient='false']">
	/**
	 * Permet de traiter les cascades ManyToMany pour les méthodes 'getList()'
	 *
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeManyToMany(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
	<!-- Gestion des cascades many-to-many (premiere pass) -->
	<xsl:call-template name="cascade-getlist-post-many2many-firstpass">
	 	<xsl:with-param name="interface" select="$interface"/>
	 	<xsl:with-param name="class" select="$class"/>
	</xsl:call-template>

	<xsl:call-template name="cascade-getlist-post-many2many-secondpass">
	 	<xsl:with-param name="interface" select="$interface"/>
	 	<xsl:with-param name="class" select="$class"/>
	</xsl:call-template>
	}
	</xsl:if>
	
	/**
	 * Permet de traiter les références et mes champs dynamiques pour les méthodes 'getList()'
	 *
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeFramework(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		for( SqlInValueCondition oSqlInValueCondition : p_listSqlInValueCondition) {
			<!-- Gestion des références -->
			<xsl:call-template name="dao-reference-cascade-getlist-references">
				<xsl:with-param name="interface" select="$interface"/>
			</xsl:call-template>
		
			<!-- Gestion des champs dynamiques -->
			<xsl:call-template name="cascade-getlist-post-champsdyn">
				<xsl:with-param name="interface" select="$interface"/>
			</xsl:call-template>
		}
	}
</xsl:template>


<!-- Gestion des cascades :
	- many-to-one
	- many-to-one et relation owner = true
 -->
<xsl:template name="cascade-getlist-post-many2one-one2oneRelationOwner">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	<xsl:param name="traitementFill">false</xsl:param>
	
	<xsl:for-each select="class/identifier/association[@transient='false' and (@type='many-to-one' or (@type='one-to-one' and @relation-owner='true'))] 
		| class/association[@transient = 'false' and (@type='many-to-one' or (@type='one-to-one' and @relation-owner='true'))]">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>)) {
		</xsl:text>
		<xsl:if test="$traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
			// Ceux avec des instances à remplir
			if ( p_oCascadeOptim.hasEntityToLoadByLoadMethod(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
				<xsl:text>this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
				<xsl:text>fillByLoadMethod( (BOList&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;) p_oCascadeOptim.getEntitiesToLoadByLoadMethod( </xsl:text>
				<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>), p_oCascadeSet, p_oContext, p_oDaoSession );
			}
		</xsl:if>
		
		BOList&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="variable-list-name"/>
		<xsl:text> = new BOListImpl&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;();
		for( SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(</xsl:text>
		<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>
		<xsl:text>))</xsl:text> {
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getSelectDaoQuery();</xsl:text>
			oDaoQuery.setExportExtSiFilter(p_oDaoQuery.getExportExtSiFilter());
			<xsl:call-template name="dao-historisation-postTraitementCascade-set-query-cascade"/>
			oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);
			<xsl:value-of select="variable-list-name"/>
			<xsl:text>.addAll(this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
		}
		
		<xsl:text>for( </xsl:text><xsl:value-of select="interface/name"/><xsl:text> </xsl:text><xsl:value-of select="variable-name"/><xsl:text> : </xsl:text><xsl:value-of select="variable-list-name"/><xsl:text>) {
			</xsl:text>for( <xsl:value-of select="$interface/name"/> oEntity<xsl:value-of select="$interface/name"/><xsl:text>: (List&lt;</xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>&gt;) p_oCascadeOptim.getListEntityForCascade(</xsl:text>
				<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text><xsl:value-of select="variable-name"/>.idToString())) {
				<xsl:if test="$traitementFill = 'false' or not($traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0)">
					<xsl:call-template name="dao-historisation-postTraitementCascade-get-map-entity-cascade">
						<xsl:with-param name="masterEntityName">oEntity<xsl:value-of select="$interface/name"/></xsl:with-param>
						<xsl:with-param name="cascadeDaoName"><xsl:text>this</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:text>.</xsl:text><xsl:value-of select="dao-interface/bean-ref"/></xsl:if></xsl:with-param>
						<xsl:with-param name="cascadeEntityName"><xsl:value-of select="variable-name"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:text>oEntity</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="set-accessor"/>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="variable-name"/>
				<xsl:text>);</xsl:text>
				<!-- TODO: A voir pour l'affectation inverse -->
			}
		}
		<xsl:if test="$traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
			<xsl:call-template name="dao-historisation-postTraitementFillCascade-get-map-entity-cascade">
				<xsl:with-param name="masterEntityName"><xsl:value-of select="$interface/name"/></xsl:with-param>
				<xsl:with-param name="cascadeDaoName"><xsl:text>this</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:text>.</xsl:text><xsl:value-of select="dao-interface/bean-ref"/></xsl:if></xsl:with-param>
				<xsl:with-param name="cascadeEntityName"><xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/><xsl:text>()</xsl:text></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:text>}
		</xsl:text>
		
	</xsl:for-each>
	
</xsl:template>



<!-- Gestion des cascades :
	- one-to-many
	- many-to-one et relation owner = false
 -->	
<xsl:template name="cascade-getlist-post-one2many-one2oneNotRelationOwner">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	<xsl:param name="traitementFill">false</xsl:param>
	
	<xsl:for-each select="class/association[@transient='false' and (@type='one-to-many' or (@type='one-to-one' and @relation-owner='false'))]">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>)) {
		</xsl:text>
			<xsl:if test="$traitementFill = 'false'">
			for (SqlInValueCondition oSqlInValueCondition : p_listSqlInValueCondition) {
			</xsl:if>
			<xsl:if test="$traitementFill = 'true'">
				<xsl:if test="count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
				// Ceux avec des instances à remplir
				if ( p_oCascadeOptim.hasEntityToLoadByLoadMethod(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
					<xsl:if test="@self-ref = 'false'">
						<xsl:text>this.</xsl:text>
						<xsl:value-of select="dao-interface/bean-ref"/>
						<xsl:text>.</xsl:text>
					</xsl:if>			
					<xsl:text>fillByLoadMethod( (BOList&lt;</xsl:text>
					<xsl:value-of select="interface/name"/>
					<xsl:text>&gt;) p_oCascadeOptim.getEntitiesToLoadByLoadMethod( </xsl:text>
					<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>), p_oCascadeSet, p_oContext, p_oDaoSession );
				}</xsl:if>
			if ( p_oCascadeOptim.hasEntityForCascade(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
				for (SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
			</xsl:if>
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if><xsl:text>getSelectDaoQuery();</xsl:text>
			oDaoQuery.setExportExtSiFilter(p_oDaoQuery.getExportExtSiFilter());
			<xsl:call-template name="dao-historisation-postTraitementCascade-set-query-cascade"/>
			oSqlInValueCondition.setFields(<xsl:value-of select="dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
			<xsl:text>, </xsl:text>
			<xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:if test="not(@self-ref = 'false')"><xsl:value-of select="//dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>ALIAS_NAME );</xsl:text>
			oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);
			 
			BOList&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="variable-list-name"/><xsl:text> = this.</xsl:text>
			<xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext);
			</xsl:text>
			
			for( <xsl:value-of select="interface/name"/>
				<xsl:text> </xsl:text><xsl:value-of select="variable-name"/> : <xsl:value-of select="variable-list-name"/> ) {
				<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/>
				<xsl:text> = (</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>) p_oCascadeOptim.getEntity( </xsl:text>
				<xsl:value-of select="variable-name"/>
				<!-- xsl:if test="@type='one-to-many'"-->
					<xsl:text>.</xsl:text>
					<xsl:value-of select="opposite-get-accessor"/>
					<xsl:text>()</xsl:text>
				<!-- /xsl:if-->
				<xsl:text>.idToString());</xsl:text>
				<xsl:if test="@type = 'one-to-many'">
					o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>
					<xsl:text>().add( </xsl:text>
					<xsl:value-of select="variable-name"/><xsl:text> );</xsl:text>
				</xsl:if>
				<xsl:if test="@type = 'one-to-one'">
					<xsl:if test="$traitementFill = 'false' or not($traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0)">
						<xsl:call-template name="dao-historisation-postTraitementCascade-get-map-entity-cascade">
							<xsl:with-param name="masterEntityName">o<xsl:value-of select="$interface/name"/></xsl:with-param>
							<xsl:with-param name="cascadeDaoName"><xsl:text>this</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:text>.</xsl:text><xsl:value-of select="dao-interface/bean-ref"/></xsl:if></xsl:with-param>
							<xsl:with-param name="cascadeEntityName"><xsl:value-of select="variable-name"/></xsl:with-param>
						</xsl:call-template></xsl:if>
					o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="set-accessor"/>
					<xsl:text>( </xsl:text><xsl:value-of select="variable-name"/><xsl:text> );</xsl:text>
				</xsl:if>
			}
			<xsl:if test="$traitementFill = 'false'">
				}
			</xsl:if>
			<xsl:if test="$traitementFill = 'true'">
				}
			}
				<xsl:if test="@type = 'one-to-one' and count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
					<xsl:call-template name="dao-historisation-postTraitementFillCascade-get-map-entity-cascade">
						<xsl:with-param name="masterEntityName"><xsl:value-of select="$interface/name"/></xsl:with-param>
						<xsl:with-param name="cascadeDaoName"><xsl:text>this</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:text>.</xsl:text><xsl:value-of select="dao-interface/bean-ref"/></xsl:if></xsl:with-param>
						<xsl:with-param name="cascadeEntityName"><xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/><xsl:text>()</xsl:text></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@type = 'one-to-many'">
				<xsl:call-template name="dao-historisation-postTraitementCascade-get-map-list-cascade">
					<xsl:with-param name="masterEntity" select="$interface"/>
					<xsl:with-param name="cascadeEntity" select="interface"/>
				</xsl:call-template>
			</xsl:if>
		}
	</xsl:for-each>
</xsl:template>



<!-- Gestion des cascades many-many
 -->	
<xsl:template name="cascade-getlist-post-many2many-firstpass">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	<xsl:param name="traitementFill">false</xsl:param>

<xsl:for-each select="class/association[@transient='false' and @type='many-to-many']">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>
		<xsl:text>)) {
		</xsl:text>
			<xsl:if test="$traitementFill = 'false'">
			for (SqlInValueCondition oSqlInValueCondition : p_listSqlInValueCondition) {
			</xsl:if>
			<xsl:if test="$traitementFill = 'true' ">
				<xsl:if test="count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
				// Ceux avec des instances à remplir
				if ( p_oCascadeOptim.hasEntityToLoadByLoadMethod(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
					<xsl:text>this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
					<xsl:text>fillByLoadMethod( (BOList&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;) p_oCascadeOptim.getEntitiesToLoadByLoadMethod( </xsl:text>
					<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>), p_oCascadeSet, p_oContext, p_oDaoSession );
				}</xsl:if>
			if ( p_oCascadeOptim.hasEntityForCascade(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
				for (SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
			</xsl:if>
			
				
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="join-table/dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getSelectDaoQuery();</xsl:text>
			oDaoQuery.setExportExtSiFilter(p_oDaoQuery.getExportExtSiFilter());
			<xsl:call-template name="dao-historisation-postTraitementCascade-set-query-cascade"/>
			oSqlInValueCondition.setFields(<xsl:value-of select="join-table/dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
			<xsl:text>, </xsl:text>
			<xsl:if test="@self-ref = 'false'"><xsl:value-of select="join-table/dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:if test="not(@self-ref = 'false')"><xsl:value-of select="//dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>ALIAS_NAME );</xsl:text>
			<xsl:text>oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);</xsl:text>
			
			<!-- Récupère les enregistrements d'asso correspondant -->
			BOList&lt;<xsl:value-of select="join-table/interface/name"/><xsl:text>&gt; list</xsl:text><xsl:value-of select="join-table/interface/name"/>
				<xsl:text> = this.</xsl:text><xsl:value-of select="join-table/dao-interface/bean-ref"/><xsl:text>.getList</xsl:text>
				<xsl:value-of select="join-table/interface/name"/><xsl:text>(oDaoQuery,p_oCascadeSet,p_oDaoSession,p_oContext);</xsl:text>
				
			<!-- Declare les associations récupérés -->
			for( <xsl:value-of select="join-table/interface/name"/><xsl:text> o</xsl:text>
				<xsl:value-of select="join-table/interface/name"/><xsl:text> : list</xsl:text><xsl:value-of select="join-table/interface/name"/> ) {
				<xsl:text>p_oCascadeOptim.registerJoinEntity( </xsl:text><xsl:value-of select="$interface/name"/><xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
				<xsl:text>, o</xsl:text><xsl:value-of select="join-table/interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="join-table/key-fields/@asso-name"/>
				<xsl:text>IdToString(), o</xsl:text><xsl:value-of select="join-table/interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="join-table/crit-fields/@asso-name"/>
				<xsl:text>IdToString(), </xsl:text>
				<xsl:for-each select="join-table/crit-fields/field">
					<xsl:text> o</xsl:text><xsl:value-of select="../../interface/name"/><xsl:text>.get</xsl:text><xsl:value-of select="@method-crit-name"/><xsl:text>()</xsl:text>
					<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:text>);</xsl:text>
			}
			<xsl:if test="$traitementFill = 'false'">
				}
			</xsl:if>
			<xsl:if test="$traitementFill = 'true'">
				}
			}
			</xsl:if>
			
		}
	
	</xsl:for-each>
</xsl:template>



<!-- 
	Gestion des cascades many-many secondpass
 -->	
<xsl:template name="cascade-getlist-post-many2many-secondpass">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	<xsl:param name="traitementFill">false</xsl:param>
	
	<!-- Deuxieme etape pour les relations many-to-many -->
	<!-- Recupere les enregistrements dans la classe dest-->
	<xsl:for-each select="class/association[@transient='false' and @type='many-to-many']">
	if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>)) {
		</xsl:text>
		BOList&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; list</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text> = new BOListImpl&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;();
		</xsl:text>
				<xsl:text>for( SqlInValueCondition oDestInClause : p_oCascadeOptim.getInClausesForJoinClasses(</xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text>
				<xsl:value-of select="dao-interface/name"/><xsl:text>.PK_FIELDS, </xsl:text><xsl:value-of select="dao-interface/name"/><xsl:text>.ALIAS_NAME )) {</xsl:text>
				<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
				<xsl:text>getSelectDaoQuery();</xsl:text>
				oDaoQuery.setExportExtSiFilter(p_oDaoQuery.getExportExtSiFilter());
				<xsl:call-template name="dao-historisation-postTraitementCascade-set-query-cascade"/>
				oDaoQuery.getSqlQuery().addToWhere(oDestInClause);
				list<xsl:value-of select="interface/name"/><xsl:text>.addAll(this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
					<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
			}
			
			<!-- Reassocie les objets -->
			for( <xsl:value-of select="interface/name"/><xsl:text> </xsl:text><xsl:value-of select="variable-name"/> : list<xsl:value-of select="interface/name"/>) {
				List&lt;String&gt; list<xsl:value-of select="$interface/name"/><xsl:text>Ids =  p_oCascadeOptim.getSourceIdsOfJoinEntitiesByTargetId( </xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text>
				<xsl:value-of select="variable-name"/><xsl:text>.</xsl:text><xsl:text>idToString());</xsl:text>
				for( String s<xsl:value-of select="$interface/name"/><xsl:text>Id : list</xsl:text><xsl:value-of select="$interface/name"/>Ids ) {
					<xsl:value-of select="$interface/name"/><xsl:text> o</xsl:text><xsl:value-of select="$interface/name"/><xsl:text> = (</xsl:text>
					<xsl:value-of select="$interface/name"/>) p_oCascadeOptim.getEntity(s<xsl:value-of select="$interface/name"/>Id);
					o<xsl:value-of select="$interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>().add(</xsl:text>
					<xsl:value-of select="variable-name"/><xsl:text>);</xsl:text>
				}
			}
			<xsl:call-template name="dao-historisation-postTraitementCascade-get-map-list-cascade">
				<xsl:with-param name="masterEntity" select="$interface"/>
				<xsl:with-param name="cascadeEntity" select="interface"/>
			</xsl:call-template>
		}
	</xsl:for-each>
</xsl:template>


<!-- 
Post traitement pour le fill
 -->

<xsl:template name="cascade-fill-post">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	
	/**
	 * Permet de traiter les cascades pour les méthodes 'fill()'
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	protected void postTraitementFillCascade(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {

		<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
		this.postTraitementFillCascadeManyToOneAndOneToOneRelationOwner(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
		this.postTraitementFillCascadeOneToManyAndOneToOneNotRelationOwner(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		<xsl:if test="class/association[@type='many-to-many' and @transient='false']">
		this.postTraitementFillCascadeManyToMany(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>

		List&lt;SqlInValueCondition&gt; listSqlInValueCondition = p_oCascadeOptim.getInClausesForMainEntities();	
		
		this.postTraitementFillCascadeFramework(listSqlInValueCondition,p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);
	}

	<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
	/**
	 * Permet de traiter les cascades ManyToOne et OneToOne pour les méthodes 'fill()'
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeManyToOneAndOneToOneRelationOwner(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		<xsl:call-template name="cascade-getlist-post-many2one-one2oneRelationOwner">
	 		<xsl:with-param name="interface" select="$interface"/>
	 		<xsl:with-param name="class" select="$class"/>
	 		<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:call-template>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@transient='false' and (@type='one-to-many' or (@type='one-to-one' and @relation-owner='false'))]">
	/**
	 * Permet de traiter les cascades OneToMany et OneToOne pour les méthodes 'fill()'
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeOneToManyAndOneToOneNotRelationOwner(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		<xsl:call-template name="cascade-getlist-post-one2many-one2oneNotRelationOwner">
		 	<xsl:with-param name="interface" select="$interface"/>
		 	<xsl:with-param name="class" select="$class"/>
		 	<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:call-template>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@transient='false' and @type='many-to-many']">
	/**
	 * Permet de traiter les cascades ManyToMany pour les méthodes 'fill()'
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeManyToMany(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		<!-- Gestion des cascades many-to-many (premiere pass) -->
		<xsl:call-template name="cascade-getlist-post-many2many-firstpass">
		 	<xsl:with-param name="interface" select="$interface"/>
		 	<xsl:with-param name="class" select="$class"/>
		 	<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:call-template>
		
		<xsl:call-template name="cascade-getlist-post-many2many-secondpass">
		 	<xsl:with-param name="interface" select="$interface"/>
		 	<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	}
	</xsl:if>
	
	/**
	 * Permet de traiter les références et mes champs dynamiques pour les méthodes 'fill()'
	 *
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeFramework(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		for( SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForMainEntities()) {
			<!-- Gestion des références -->
			<xsl:call-template name="dao-reference-cascade-getlist-references">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="traitementFill" select="'true'"/>
			</xsl:call-template>
			<!-- Champs dynamiques -->
			<xsl:call-template name="cascade-getlist-post-champsdyn">
				<xsl:with-param name="interface" select="$interface"/>
			</xsl:call-template>
		}
	}
</xsl:template>


<!--
Traitement des champs dynamiques dans les méthodes postTraitement 
 -->
<xsl:template name="cascade-getlist-post-champsdyn">
	<xsl:param name="interface"/>

	<!-- Gestion des champs dynamiques -->
	<xsl:if test="count(class/identifier/descendant::attribute) = 1">
	/*DISABLED IN BACKPORT
	if ( !p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) 
		<xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.NOT_DYN)) { 
			this.dynamicalFieldDao.addDynamicalFieldsToEntities(<xsl:value-of select="$interface/name"/>.ENTITY_NAME.toLowerCase(), p_oCascadeOptim, oSqlInValueCondition, p_oContext);
	}
	*/
	</xsl:if>
	
</xsl:template>

</xsl:stylesheet>
