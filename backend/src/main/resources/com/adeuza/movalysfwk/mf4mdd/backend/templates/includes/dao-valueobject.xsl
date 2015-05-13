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


<!-- Value un objet à partir du ResultSet -->
<xsl:template name="dao-valueobject">
	<xsl:param name="class" select="class"/>
	<xsl:param name="interface" select="interface"/>
	
	/**
	 * @param p_oResultSet résultat de la requête
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao	 
	 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
	 * @param p_oContext contexte transactionnel
	 *
	 * @return l'entité <xsl:value-of select="interface/name"/>
	 *
	 * @throws SQLException déclenchée si une erreur SQL survient
	 * @throws DaoException déclenchée si une exception technique survient
	 * @throws IOException déclenchée si une erreur d'entrée/sortie survient
	 */
	protected <xsl:value-of select="interface/name"/> valueObject( ResultSetReader p_oResultSetReader, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession,
		CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws SQLException, DaoException, IOException {
		
		<xsl:call-template name="dao-historisation-valueobject-single-begin"/>
		
		<xsl:value-of select="interface/name"/> r_o<xsl:value-of select="interface/name"/> = this.<xsl:value-of select="class/pojo-factory-interface/bean-name"/>.createInstanceNoChangeRecord();
		
		<!-- Traite d'abord la clé primaire (sans faire les cascades)-->
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="jdbc-retrieve-pk-firstpass">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:call-template name="dao-value-object-getfromcache">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
		
			<!-- Traitement des cascades sur la clé primaire -->
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:call-template name="jdbc-retrieve-pk-secondpass">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="optimList" select="'false'"/>
					<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		
			<!-- Traite ensuite les autre champs -->	
			<xsl:for-each select="class/descendant::attribute[@transient = 'false' and not(ancestor::identifier)]">
				<xsl:call-template name="jdbc-retrieve">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="optimList" select="'false'"/>
					<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			
			<!-- Traite les cascades vers n -->
			<xsl:for-each select="class/association[(@type='one-to-many' or @type='many-to-many' or (@type='one-to-one' and @relation-owner='false')) and not(parent::association) and @transient = 'false']">
			
				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
				
				<xsl:text>DaoQuery oDaoQuery = </xsl:text>
				<xsl:if test="@self-ref = 'false'">
					<xsl:text>this.</xsl:text>
					<xsl:value-of select="dao-interface/bean-ref"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:text>getSelectDaoQuery();</xsl:text>
				oDaoQuery.setExportExtSiFilter(p_oDaoQuery.getExportExtSiFilter());
				<xsl:call-template name="dao-historisation-valueobject-single-set-query-cascade"/>
				r_o<xsl:value-of select="$interface/name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="set-accessor"/>
				<xsl:text>( </xsl:text>
				
				<xsl:if test="@self-ref = 'false'">
					<xsl:text>this.</xsl:text>
					<xsl:value-of select="dao-interface/bean-ref"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				
				<xsl:text>get</xsl:text>
				<xsl:if test="@type='one-to-many' or @type='many-to-many'">
					<xsl:text>List</xsl:text>
				</xsl:if>
				<xsl:value-of select="interface/name"/>
				<xsl:text>By</xsl:text>
				<xsl:value-of select="method-crit-opposite-name"/>
				<xsl:text>(</xsl:text>
					<xsl:for-each select="$class/identifier/*">
						<xsl:text>r_o</xsl:text>
						<xsl:value-of select="$interface/name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="get-accessor"/>
						<xsl:text>(), </xsl:text>
					</xsl:for-each>
				<xsl:text>oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
				<xsl:call-template name="dao-historisation-valueobject-single-get-query-cascade"/>
				}
			</xsl:for-each>
			
			<xsl:call-template name="dao-reference-cascade-get-references">
				<xsl:with-param name="interface" select="$interface"/>
			</xsl:call-template>
			
			<xsl:if test="count($class/identifier/descendant::attribute) = 1">
				/*DISABLED IN BACKPORT
				if(r_o<xsl:value-of select="interface/name"/><xsl:text> != null </xsl:text><xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="interface/name"/>.Cascade.NOT_DYN)){
					this.dynamicalFieldDao.addDynamicalFieldsToEntity(<xsl:value-of select="interface/name"/>.ENTITY_NAME.toLowerCase(), r_o<xsl:value-of select="interface/name"/>, p_oContext );
				}
				*/
			</xsl:if>

		<xsl:text>}
		else {
			r_o</xsl:text>
			<xsl:value-of select="interface/name"/> = oCached<xsl:value-of select="interface/name"/> ;
			p_oResultSetReader.setPositionToCustomFields(p_oDaoQuery, <xsl:value-of select="dao-interface/name"/>
			<xsl:text>.NB_FIELDS, </xsl:text><xsl:value-of select="dao-interface/name"/>.NB_I18N_FIELDS);
		}
		
		<xsl:call-template name="dao-value-object-readextraresultset">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="entity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="dao-historisation-valueobject-single-end">
			<xsl:with-param name="interfaceName">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>
		
		return r_o<xsl:value-of select="interface/name"/> ;
	}
	
</xsl:template>




<!-- Value un objet à partir du ResultSet en utilisant la méthode optimisée pour les listes -->
<xsl:template name="dao-valueobject-optimlist">
	<xsl:param name="interface" select="interface"/>
	<xsl:param name="class" select="class"/>
	
	/**
	 * @param p_oResultSet résultat de la requête
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao	 
	 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades
	 *
	 * @return l'entité <xsl:value-of select="interface/name"/>
	 *
	 * @throws SQLException déclenchée si une erreur SQL survient
	 * @throws IOException déclenchée si une erreur d'entrée/sortie survient
	 */
	protected <xsl:value-of select="interface/name"/> valueObject( ResultSetReader p_oResultSetReader, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession,
		CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim, ItfTransactionalContext p_oContext ) throws SQLException, IOException {
		
		<xsl:value-of select="interface/name"/> r_o<xsl:value-of select="interface/name"/> = this.<xsl:value-of select="class/pojo-factory-interface/bean-name"/>.createInstanceNoChangeRecord();
		
		<!-- Traite d'abord la clé primaire (sans faire les cascades)-->
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="jdbc-retrieve-pk-firstpass">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		String sEntityId = r_o<xsl:value-of select="interface/name"/>.idToString();
		<xsl:call-template name="dao-value-object-getfromcache">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="hasVariableEntityId" select="'true'"/>
		</xsl:call-template>
			
			<xsl:text>p_oCascadeOptim.registerEntity(sEntityId,r_o</xsl:text>
			<xsl:value-of select="interface/name"/>
			<xsl:text>, </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>.</xsl:text>
				<xsl:if test="parent::association">
					<xsl:value-of select="../get-accessor"/>
					<xsl:text>().</xsl:text>	
				</xsl:if>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>()</xsl:text>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:text> );
			</xsl:text>
		
			<!-- Traitement des cascades sur la clé primaire -->
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:call-template name="jdbc-retrieve-pk-secondpass">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="optimList" select="'true'"/>
					<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		
			<!-- Traite ensuite les autre champs -->
			<xsl:for-each select="class/descendant::attribute[@transient = 'false' and not(ancestor::identifier)]">
				<xsl:call-template name="jdbc-retrieve">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="optimList" select="'true'"/>
					<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			
			<!-- Traite les cascades vers n -->
			<xsl:call-template name="cascade-getlist-preTraitementCascadeN">
				<xsl:with-param name="interface" select="interface"/>
			</xsl:call-template>
			
		<xsl:text>}
		else {
			r_o</xsl:text>
			<xsl:value-of select="interface/name"/> = oCached<xsl:value-of select="interface/name"/> ;
			p_oResultSetReader.setPositionToCustomFields(p_oDaoQuery, <xsl:value-of select="dao-interface/name"/>
			<xsl:text>.NB_FIELDS, </xsl:text><xsl:value-of select="dao-interface/name"/>.NB_I18N_FIELDS);
		}
		
		<xsl:call-template name="dao-value-object-readextraresultset">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="entity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>
		
		return r_o<xsl:value-of select="interface/name"/> ;
	}
	
</xsl:template>

<!--
 Essaie de récupérer l'entité dans le cache après avoir lu sa clé primaire
 dans le résultset.
 Deux manières différentes en fonction de si l'entité est MethodLoadable ou pas 
 -->
<xsl:template name="dao-value-object-getfromcache">
	<xsl:param name="class"/>
	<xsl:param name="hasVariableEntityId">false</xsl:param>

	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) = 0 and $hasVariableEntityId = 'false'">
	String sEntityId = r_o<xsl:value-of select="interface/name"/>.idToString();
	</xsl:if>

	<xsl:value-of select="interface/name"/>
	<xsl:text> oCached</xsl:text>
	<xsl:value-of select="interface/name"/>
	<xsl:text> = (</xsl:text>
	<xsl:value-of select="interface/name"/>
	<xsl:text>) p_oDaoSession.getFromCache(</xsl:text>
	<xsl:value-of select="interface/name"/>
	<xsl:text>.ENTITY_NAME, </xsl:text>

	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) = 0 ">
		
		<xsl:text> sEntityId );</xsl:text>
			
		if ( oCached<xsl:value-of select="interface/name"/> == null ) {
		
			p_oDaoSession.addToCache(<xsl:value-of select="interface/name"/>
			<xsl:text>.ENTITY_NAME, sEntityId, r_o</xsl:text>
			<xsl:value-of select="interface/name"/><xsl:text> );
			</xsl:text>
	</xsl:if>
		
	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0 ">
		
 		<xsl:text> LoadMethod</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text>.BY_ID.getHelper().getCacheKeyOfEntity(r_o</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text>) );</xsl:text>
	
		if ( oCached<xsl:value-of select="interface/name"/> == null ) {
			p_oDaoSession.addToCache(<xsl:value-of select="interface/name"/>.ENTITY_NAME, LoadMethod<xsl:value-of select="interface/name"/>
			<xsl:text>.BY_ID.getHelper().getCacheKeyOfEntity(r_o</xsl:text><xsl:value-of select="interface/name"/>
			<xsl:text>), r_o</xsl:text><xsl:value-of select="interface/name"/>);
	</xsl:if>

</xsl:template>


<xsl:template name="dao-value-object-readextraresultset">
	<xsl:param name="class"/>
	<xsl:param name="interface"/>
	<xsl:param name="entity"/>

	<xsl:variable name="attrs" select="$class/descendant::attribute[(not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]"/>
	<xsl:variable name="pos" select="$attrs[last()]/@pos"/>
	p_oDaoQuery.doResultSetCustomRead( <xsl:value-of select="$entity"/>, p_oResultSetReader, p_oDaoSession, p_oCascadeSet);
</xsl:template>

</xsl:stylesheet>