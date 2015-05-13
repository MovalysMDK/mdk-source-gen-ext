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

<xsl:template match="dao" mode="create-cascade-get-list-post">
	/**
	 * Permet de traiter les cascades pour les méthodes 'getList()'
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Override
	protected void postTraitementCascade(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
	
		<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
		this.postTraitementCascadeManyToOneAndOneToOneRelationOwner(p_oCascadeOptim.getInClausesForMainEntities(), p_oCascadeSet, p_oCascadeOptim, p_oDaoQuery, p_oDaoSession, p_oContext);</xsl:if>

		<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
		this.postTraitementCascadeOneToManyAndOneToOneNotRelationOwner(p_oCascadeOptim.getInClausesForMainEntities(), p_oCascadeSet, p_oCascadeOptim, p_oDaoQuery, p_oDaoSession, p_oContext);</xsl:if>

		<xsl:if test="class/association[@transient = 'false' and @type='many-to-many']">
		this.postTraitementCascadeManyToMany(p_oCascadeOptim.getInClausesForMainEntities(), p_oCascadeSet, p_oCascadeOptim, p_oDaoQuery, p_oDaoSession, p_oContext);</xsl:if>

		<xsl:if test="class[customizable='true']">
			if (p_oCascadeSet.contains(CascadeSet.GenericCascade.CUSTOM_FIELDS) || p_oCascadeSet.contains(<xsl:value-of select="class/implements/interface/@name"/>Cascade.CUSTOM_FIELDS)) {
				for (SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForMainEntities()) {
					DaoQuery oDaoQuery = this.customFieldDao.getSelectDaoQuery();
					oSqlInValueCondition.setFields(CustomFieldDao.FK_ENTITY, CustomFieldDao.ALIAS_NAME);
					oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);

					Collection&lt;CustomField&gt; listCustomFields = this.customFieldDao.getListCustomField(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext);

					for (CustomField oCustomField : listCustomFields) {
						<xsl:value-of select="class/implements/interface/@name"/> oEntity = (<xsl:value-of select="class/implements/interface/@name"/>) p_oCascadeOptim.getEntity(oCustomField.getIdref());
						oEntity.setCustomField(oCustomField.getFieldName(), oCustomField.getStrValues());
					}
				
				}
			}
		</xsl:if>
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
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeManyToOneAndOneToOneRelationOwner(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
	<xsl:apply-templates select="." mode="cascade-getlist-post-many2one-one2oneRelationOwner"/>
	}
	</xsl:if>

	<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
	/**
	 * Permet de traiter les cascades OneToMany et OneToOne pour les méthodes 'getList()'
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeOneToManyAndOneToOneNotRelationOwner(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
	<xsl:apply-templates select="." mode="cascade-getlist-post-one2many-one2oneNotRelationOwner"/>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@type='many-to-many' and @transient='false']">
	/**
	 * Permet de traiter les cascades ManyToMany pour les méthodes 'getList()'
	 * @param p_listSqlInValueCondition Liste des conditions des valeurs
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementCascadeManyToMany(List&lt;SqlInValueCondition&gt; p_listSqlInValueCondition, CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
	<!-- Gestion des cascades many-to-many (premiere pass) -->
	<xsl:apply-templates select="." mode="cascade-getlist-post-many2many-firstpass"/>
	<xsl:apply-templates select="." mode="cascade-getlist-post-many2many-secondpass"/>
	}
	</xsl:if>
</xsl:template>


<!-- Gestion des cascades :
	- many-to-one
	- many-to-one et relation owner = true
 -->
<xsl:template match="dao" mode="cascade-getlist-post-many2one-one2oneRelationOwner">
	<xsl:param name="traitementFill">false</xsl:param>
	<xsl:variable name="interface" select="interface"/>

	<xsl:for-each select="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@transient = 'false' and (@type='many-to-one' or (@type='one-to-one' and @relation-owner='true'))]">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>)) {
		</xsl:text>
		Collection&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="variable-list-name"/>
		<xsl:text> = new ArrayList&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;();
		for( SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(</xsl:text>
		<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
		<xsl:text>))</xsl:text> {
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getSelectDaoQuery();</xsl:text>
			oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);
			<xsl:value-of select="variable-list-name"/>
			<xsl:text>.addAll(this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
		}
		
		<xsl:text>for( </xsl:text><xsl:value-of select="interface/name"/><xsl:text> </xsl:text><xsl:value-of select="variable-name"/><xsl:text> : </xsl:text><xsl:value-of select="variable-list-name"/><xsl:text>) {
		
			</xsl:text>@SuppressWarnings("unchecked")
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>&gt; list</xsl:text><xsl:value-of select="$interface/name"/><xsl:text> = (List&lt;</xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>&gt;) p_oCascadeOptim.getListEntityForCascade(</xsl:text>
				<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text><xsl:value-of select="variable-name"/>.idToString());

			for( <xsl:value-of select="$interface/name"/> oEntity<xsl:value-of select="$interface/name"/><xsl:text>: list</xsl:text><xsl:value-of select="$interface/name"/>) {
				<xsl:text>oEntity</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="set-accessor"/>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="variable-name"/>
				<xsl:text>);</xsl:text>
				<!-- TODO: A voir pour l'affectation inverse -->
			}
		}
		<xsl:text>}
		</xsl:text>
		
	</xsl:for-each>
	
</xsl:template>



<!-- Gestion des cascades :
	- one-to-many
	- many-to-one et relation owner = false
 -->	
<xsl:template match="dao" mode="cascade-getlist-post-one2many-one2oneNotRelationOwner">
	<xsl:param name="traitementFill">false</xsl:param>
	<xsl:variable name="interface" select="interface"/>

	<xsl:for-each select="class/association[@transient = 'false' and (@type='one-to-many' or (@type='one-to-one' and @relation-owner='false'))]">
			
			<xsl:if test="$traitementFill = 'false'">
				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>
				<xsl:text>Cascade.</xsl:text>
				<xsl:value-of select="@cascade-name"/>
				<xsl:text>)) {
				</xsl:text>			
				for (SqlInValueCondition oSqlInValueCondition : p_listSqlInValueCondition) {
			</xsl:if>
			
			<xsl:if test="$traitementFill = 'true'">
				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
				<xsl:text>) &amp;&amp; p_oCascadeOptim.hasEntityForCascade(</xsl:text>
				<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
				<xsl:text>)) {
				</xsl:text>
				for (SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
			</xsl:if>
			
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if><xsl:text>getSelectDaoQuery();</xsl:text>
			oSqlInValueCondition.setFields(<xsl:value-of select="dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
			<xsl:text>, </xsl:text>
			<xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:if test="not(@self-ref = 'false')"><xsl:value-of select="//dao-interface/name"/><xsl:text>.</xsl:text></xsl:if>
			<xsl:text>ALIAS_NAME );</xsl:text>
			oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);

			Collection&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="variable-list-name"/><xsl:text> = this.</xsl:text>
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
					o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="set-accessor"/>
					<xsl:text>( </xsl:text><xsl:value-of select="variable-name"/><xsl:text> );</xsl:text>
				</xsl:if>
			}
			
			<xsl:if test="$traitementFill = 'false'">
				}
			</xsl:if>
			<xsl:if test="$traitementFill = 'true'">
				}
			</xsl:if>
		}
	</xsl:for-each>
</xsl:template>



<!-- Gestion des cascades many-many
 -->	
<xsl:template match="dao" mode="cascade-getlist-post-many2many-firstpass">
	<xsl:param name="traitementFill">false</xsl:param>

	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="class" select="class"/>

	<xsl:for-each select="class/association[@type='many-to-many' and @transient='false']">
			<xsl:if test="$traitementFill = 'false'">
			if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
			<xsl:text>)) {
			for (SqlInValueCondition oSqlInValueCondition : p_listSqlInValueCondition) {
</xsl:text>
			</xsl:if>
			
			<xsl:if test="$traitementFill = 'true' ">
				
				<xsl:if test="count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
					<xsl:text>)) {
				</xsl:text>
				// Ceux avec des instances à remplir
				if ( p_oCascadeOptim.hasEntityToLoadByLoadMethod(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
					<xsl:text>this.</xsl:text><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text>
					<xsl:text>fillByLoadMethod( (Collection&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;) p_oCascadeOptim.getEntitiesToLoadByLoadMethod( </xsl:text>
					<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>), p_oCascadeSet, p_oContext, p_oDaoSession );
				}
				if ( p_oCascadeOptim.hasEntityForCascade(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
				</xsl:if>
				
				<xsl:if test="not( count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0)">
				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
					<xsl:text>) &amp;&amp; </xsl:text>
					<xsl:text>p_oCascadeOptim.hasEntityForCascade(</xsl:text>
					<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
					<xsl:text>)) {
				</xsl:text>
				</xsl:if>
				
				for (SqlInValueCondition oSqlInValueCondition : p_oCascadeOptim.getInClausesForCascade(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
			</xsl:if>
			
				
			<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:value-of select="join-table/dao-interface/bean-ref"/><xsl:text>.</xsl:text>
			<xsl:text>getSelectDaoQuery();</xsl:text>
			oSqlInValueCondition.setFields(<xsl:value-of select="join-table/dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="join-table/dao-interface/name"/><xsl:text>.</xsl:text>
			<xsl:text>ALIAS_NAME );</xsl:text>
			<xsl:text>oDaoQuery.getSqlQuery().addToWhere(oSqlInValueCondition);</xsl:text>
			
			<!-- Récupère les enregistrements d'asso correspondant -->
			Collection&lt;<xsl:value-of select="join-table/interface/name"/><xsl:text>&gt; list</xsl:text><xsl:value-of select="join-table/interface/name"/>
				<xsl:text> = this.</xsl:text><xsl:value-of select="join-table/dao-interface/bean-ref"/><xsl:text>.getList</xsl:text>
				<xsl:value-of select="join-table/interface/name"/><xsl:text>(oDaoQuery,p_oCascadeSet,p_oDaoSession,p_oContext);</xsl:text>
				
			<!-- Declare les associations récupérés -->
			for( <xsl:value-of select="join-table/interface/name"/><xsl:text> o</xsl:text>
				<xsl:value-of select="join-table/interface/name"/><xsl:text> : list</xsl:text><xsl:value-of select="join-table/interface/name"/> ) {
				<xsl:text>p_oCascadeOptim.registerJoinEntity( </xsl:text><xsl:value-of select="$interface/name"/><xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
				<xsl:text>, o</xsl:text><xsl:value-of select="join-table/interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="join-table/key-fields/@asso-name"/>
				<xsl:text>IdToString(), o</xsl:text><xsl:value-of select="join-table/interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="join-table/crit-fields/@asso-name"/>
				<xsl:text>IdToString(), </xsl:text>
				<xsl:for-each select="join-table/crit-fields/field">
					<xsl:text> o</xsl:text><xsl:value-of select="../../interface/name"/><xsl:text>.get</xsl:text><xsl:value-of select="@method-crit-name"/><xsl:text>()</xsl:text>
					<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
				<xsl:text>);</xsl:text>
			}
			}
		}
	</xsl:for-each>
</xsl:template>



<!-- 
	Gestion des cascades many-many secondpass
 -->	
<xsl:template match="dao" mode="cascade-getlist-post-many2many-secondpass">
	<xsl:param name="traitementFill">false</xsl:param>
	
	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="class" select="class"/>
	
	<!-- Deuxieme etape pour les relations many-to-many -->
	<!-- Recupere les enregistrements dans la classe dest-->
	<xsl:for-each select="class/association[@transient = 'false' and @type='many-to-many']">
	if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/><xsl:text>)) {
		</xsl:text>
		Collection&lt;<xsl:value-of select="interface/name"/><xsl:text>&gt; list</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text> = new ArrayList&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt;();
		</xsl:text>
				<xsl:text>for( SqlInValueCondition oDestInClause : p_oCascadeOptim.getInClausesForJoinClasses(</xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text>
				<xsl:value-of select="dao-interface/name"/><xsl:text>.PK_FIELDS, </xsl:text><xsl:value-of select="dao-interface/name"/><xsl:text>.ALIAS_NAME )) {&#13;</xsl:text>
				<xsl:text>DaoQuery oDaoQuery = this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
				<xsl:text>getSelectDaoQuery();</xsl:text>
				oDaoQuery.getSqlQuery().addToWhere(oDestInClause);
				list<xsl:value-of select="interface/name"/><xsl:text>.addAll(this.</xsl:text><xsl:if test="@self-ref = 'false'"><xsl:value-of select="dao-interface/bean-ref"/><xsl:text>.</xsl:text></xsl:if>
					<xsl:text>getList</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
			}
			
			<!-- Reassocie les objets -->
			for( <xsl:value-of select="interface/name"/><xsl:text> </xsl:text><xsl:value-of select="variable-name"/> : list<xsl:value-of select="interface/name"/>) {
				List&lt;String&gt; list<xsl:value-of select="$interface/name"/><xsl:text>Ids =  p_oCascadeOptim.getSourceIdsOfJoinEntitiesByTargetId( </xsl:text>
				<xsl:value-of select="$interface/name"/><xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text>, </xsl:text>
				<xsl:value-of select="variable-name"/><xsl:text>.</xsl:text><xsl:text>idToString());</xsl:text>
				for( String s<xsl:value-of select="$interface/name"/><xsl:text>Id : list</xsl:text><xsl:value-of select="$interface/name"/>Ids ) {
					<xsl:value-of select="$interface/name"/><xsl:text> o</xsl:text><xsl:value-of select="$interface/name"/><xsl:text> = (</xsl:text>
					<xsl:value-of select="$interface/name"/>) p_oCascadeOptim.getEntity(s<xsl:value-of select="$interface/name"/>Id);
					o<xsl:value-of select="$interface/name"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>().add(</xsl:text>
					<xsl:value-of select="variable-name"/><xsl:text>);</xsl:text>
				}
			}
		}
	</xsl:for-each>
</xsl:template>


<!-- 
Post traitement pour le fill
 -->

<xsl:template match="dao" mode="cascade-fill-post">
	/**
	 * Permet de traiter les cascades pour les méthodes 'fill()'
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	protected void postTraitementFillCascade(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {

		<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
		this.postTraitementFillCascadeManyToOneAndOneToOneRelationOwner(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
		this.postTraitementFillCascadeOneToManyAndOneToOneNotRelationOwner(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
		
		<xsl:if test="class/association[@type='many-to-many' and @transient='false']">
		this.postTraitementFillCascadeManyToMany(p_oCascadeSet,p_oCascadeOptim,p_oDaoQuery,p_oDaoSession,p_oContext);</xsl:if>
	}

	<xsl:if test="class/identifier/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')] 
		| class/association[@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')]">
	/**
	 * Permet de traiter les cascades ManyToOne et OneToOne pour les méthodes 'fill()'
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeManyToOneAndOneToOneRelationOwner(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		<xsl:apply-templates select="." mode="cascade-getlist-post-many2one-one2oneRelationOwner">
			<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:apply-templates>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@type='one-to-many' or (@type='one-to-one' and @relation-owner='false')]">
	/**
	 * Permet de traiter les cascades OneToMany et OneToOne pour les méthodes 'fill()'
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeOneToManyAndOneToOneNotRelationOwner(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		<xsl:apply-templates select="." mode="cascade-getlist-post-one2many-one2oneNotRelationOwner">
			<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:apply-templates>
	}
	</xsl:if>
	
	<xsl:if test="class/association[@type='many-to-many' and @transient='false']">
	/**
	 * Permet de traiter les cascades ManyToMany pour les méthodes 'fill()'
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	private void postTraitementFillCascadeManyToMany(CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim,
		DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		<!-- Gestion des cascades many-to-many (premiere pass) -->
		<xsl:apply-templates select="." mode="cascade-getlist-post-many2many-firstpass">
			<xsl:with-param name="traitementFill" select="'true'"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="cascade-getlist-post-many2many-secondpass"/>
	}
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
