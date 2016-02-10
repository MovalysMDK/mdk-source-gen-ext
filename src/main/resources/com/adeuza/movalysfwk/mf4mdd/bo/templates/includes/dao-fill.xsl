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

<xsl:template name="dao-fill">
	
	<xsl:param name="class"/>
	<xsl:param name="interface"/>
	
	<xsl:variable name="entityToFill">o<xsl:value-of select="$interface/name"/>ToFill</xsl:variable>
	<xsl:variable name="cacheEntity">oCache<xsl:value-of select="$interface/name"/></xsl:variable>
	
	/**
	 * {@inheritDoc}
	 */	
	protected void fillObject( BOList&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, ResultSetReader p_oResultSetReader, LoadMethod&lt;</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>&gt; p_oLoadMethod,</xsl:text>
			DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext,
			CascadeOptim p_oCascadeOptim ) throws SQLException, IOException, DaoException {
		
		<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0 ">
		
			<!-- Récupère la valeur de l'identifiant suivant la load méthod -->
			<xsl:text>Object oIdentifiantByLoadMethod = p_oLoadMethod.getHelper().readIdentifiant(p_oResultSetReader.getResultSet(), 
				this.getReferenceMap().get(p_oLoadMethod).getIdentifiantColNames());
			</xsl:text>
			
			<!-- Essaie de récupérer l'entité en cachant suivant la load méthod -->
			<xsl:value-of select="$interface/name"/><xsl:text> </xsl:text><xsl:value-of select="$cacheEntity"/>
				<xsl:text> = (</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>) p_oDaoSession.getFromCache(</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>.ENTITY_NAME,	p_oLoadMethod.getHelper().getCacheKeyOfIdenfiant(oIdentifiantByLoadMethod));
			</xsl:text>
				
			<!-- Si pas trouvé -->
			<xsl:text>if (</xsl:text><xsl:value-of select="$cacheEntity"/> == null) {
			
				<xsl:value-of select="$interface/name"/><xsl:text> </xsl:text><xsl:value-of select="$entityToFill"/>
					<xsl:text> = (</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>) p_oLoadMethod.getHelper().search( (Collection) p_list</xsl:text>
					<xsl:value-of select="$interface/name"/><xsl:text>, oIdentifiantByLoadMethod );</xsl:text>
				
				<!-- les entités sont forcément identifiables -->
				<xsl:value-of select="$entityToFill"/>.setId(p_oResultSetReader.getLong());
	
				<!-- Essaie de récupérer la valeur en cache avec l'id database -->
				<xsl:value-of select="$cacheEntity"/> = (<xsl:value-of select="$interface/name"/>
					<xsl:text>) p_oDaoSession.getFromCache(</xsl:text>
					<xsl:value-of select="$interface/name"/>.ENTITY_NAME, 
					LoadMethod<xsl:value-of select="$interface/name"/>
					<xsl:text>.BY_ID.getHelper().getCacheKeyOfEntity(</xsl:text>
					<xsl:value-of select="$entityToFill"/><xsl:text>));
				</xsl:text>

				if (<xsl:value-of select="$cacheEntity"/> == null) {
				
					p_oDaoSession.addToCache(<xsl:value-of select="$interface/name"/>.ENTITY_NAME, 
						LoadMethod<xsl:value-of select="$interface/name"/>.BY_ID.getHelper().getCacheKeyOfEntity(
								<xsl:value-of select="$entityToFill"/>), <xsl:value-of select="$entityToFill"/>);
					if ( LoadMethod<xsl:value-of select="$interface/name"/>.BY_ID != p_oLoadMethod ) {
						p_oDaoSession.addToCache(<xsl:value-of select="$interface/name"/>
						<xsl:text>.ENTITY_NAME, p_oLoadMethod.getHelper().getCacheKeyOfEntity(</xsl:text>
						<xsl:value-of select="$entityToFill"/><xsl:text>), </xsl:text><xsl:value-of select="$entityToFill"/>);
					}
				
					HistorisationEntityLevelType oHistorisationEntityLevelType = this.getHelperHistorisationBlocLevel().retreiveHistorisationEntityLevelType(p_oResultSetReader.getHistoLevel());
					<xsl:value-of select="$entityToFill"/>.getEntityHistorisationBlocMap().put(this.getHistorisationBlocType(), oHistorisationEntityLevelType);
					this.simplifyEntityHistorisationBlocMap(<xsl:value-of select="$entityToFill"/>);
					Set&lt;HistorisationEntityLevelType&gt; setHistorisationEntityLevelType = ((DaoQueryImpl) p_oDaoQuery).getQueryHistorisationBlocMap().get(this.getHistorisationBlocType());
					setHistorisationEntityLevelType.add(oHistorisationEntityLevelType);
					((DaoQueryImpl) p_oDaoQuery).getQueryHistorisationBlocMap().put(this.getHistorisationBlocType(), setHistorisationEntityLevelType);
				
					<xsl:value-of select="$entityToFill"/>.setLoadMethod(LoadMethod<xsl:value-of select="$interface/name"/>.BY_ID);
					<xsl:text>p_oCascadeOptim.registerEntity(</xsl:text><xsl:value-of select="$entityToFill"/>
					<xsl:text>.idToString(), </xsl:text><xsl:value-of select="$entityToFill"/><xsl:text>, </xsl:text>
					<xsl:for-each select="class/identifier/descendant::attribute">
						<xsl:value-of select="$entityToFill"/>
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
					
					<!-- Traite les champs simples -->
					<xsl:for-each select="class/descendant::attribute[not(ancestor::identifier)]">
						<xsl:call-template name="jdbc-retrieve">
							<xsl:with-param name="interface" select="$interface"/>
							<xsl:with-param name="optimList" select="'true'"/>
							<xsl:with-param name="object" select="$entityToFill"/>
							<xsl:with-param name="traitementFill" select="'true'"/>
							<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					
					<!-- Traite les cascades vers n -->
					<xsl:call-template name="cascade-getlist-preTraitementCascadeN">
						<xsl:with-param name="interface" select="interface"/>
						<xsl:with-param name="object" select="$entityToFill"/>
						<xsl:with-param name="traitementFill" select="'true'"/>
					</xsl:call-template>

					<xsl:call-template name="dao-value-object-readextraresultset">
						<xsl:with-param name="class" select="$class"/>
						<xsl:with-param name="interface" select="$interface"/>
						<xsl:with-param name="entity"><xsl:value-of select="$entityToFill"/></xsl:with-param>
					</xsl:call-template>
					
				} else {
					p_list<xsl:value-of select="$interface/name"/>.replace(<xsl:value-of select="$cacheEntity"/>, p_oLoadMethod);
				}
			
			} else {
				p_list<xsl:value-of select="$interface/name"/>.replace(<xsl:value-of select="$cacheEntity"/>, p_oLoadMethod);
			}
			
			// Initialise les champs dynamiques sur les entités non chargées
			/*DISABLED IN BACKPORT
			for( <xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : p_list<xsl:value-of select="$interface/name"/> ) {
				if ( p_oDaoSession.getFromCache(getEntityName(), p_oLoadMethod.getHelper().getCacheKeyOfEntity( o<xsl:value-of select="$interface/name"/>
					<xsl:text> )) == null ) {</xsl:text>
					this.dynamicalFieldDao.initDynamicalFieldsNoRecursive( p_oDaoSession, p_oContext, o<xsl:value-of select="$interface/name"/>);
				}
			}
			*/
		</xsl:if>
		
		<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) = 0 ">
		throw new UnsupportedOperationException("L'entité <xsl:value-of select="$interface/name"/> n'est pas MethodLoadable");
		</xsl:if>
	}
		
	/**
	 * {@inheritDoc}
	 */
	protected void fillRegisterCascadeOnNotLoadedObject( BOList&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, LoadMethod&lt;</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>&gt; p_oLoadMethod, DaoSession p_oDaoSession, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext,</xsl:text>		
			CascadeOptim p_oCascadeOptim ) throws SQLException, IOException {
		
		<xsl:if test="class/association">
		for( <xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : p_list<xsl:value-of select="$interface/name"/> ) {
			if ( p_oDaoSession.getFromCache(getEntityName(), p_oLoadMethod.getHelper().getCacheKeyOfEntity( o<xsl:value-of select="$interface/name"/>
				<xsl:text> )) == null ) {</xsl:text>
				
				<xsl:for-each select="class/association">
				
					<!-- la classe destination doit etre MethodLoadable -->
					<xsl:if test="count(interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0 ">
				
					if (o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>() != null &amp;&amp;
						p_oCascadeSet.contains( <xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="@cascade-name"/> )) {
						
						<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
							<!-- test d'abord dans le cache -->
							<xsl:value-of select="interface/name"/>  oCache<xsl:value-of select="interface/name"/>
							<xsl:text>  = (</xsl:text><xsl:value-of select="interface/name"/>
							<xsl:text> ) p_oDaoSession.getFromCache( </xsl:text><xsl:value-of select="interface/name"/>
							<xsl:text>.ENTITY_NAME,	o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>
							<xsl:text>().getLoadMethod().getHelper().getCacheKeyOfEntity( o</xsl:text>
							<xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>()));
							if (oCache<xsl:value-of select="interface/name"/> == null) {
								<!-- si pas présent, on enregistre l'entité pour qu'elle soit chargée -->
								p_oCascadeOptim.registerEntityForCascadeUsingLoadMethod(<xsl:value-of select="$interface/name"/>
								<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>,
									o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>());
							}
							else {
								<!-- si présent, on remplace -->
								o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="set-accessor"/>
								<xsl:text>(oCache</xsl:text><xsl:value-of select="interface/name"/>);
							}
						</xsl:if>
						
						<xsl:if test="@type = 'one-to-many' or @type = 'many-to-many'">
						
							<!-- liste des éléments qu'on va remplacer -->
							Map&lt;<xsl:value-of select="interface/name"/>
							<xsl:text>, LoadMethod&gt; mapReplace = new HashMap&lt;</xsl:text>
							<xsl:value-of select="interface/name"/>,LoadMethod&gt;();
						
							for( <xsl:value-of select="interface/name"/> oEntity<xsl:value-of select="interface/name"/> 
								<xsl:text> : o</xsl:text><xsl:value-of select="$interface/name"/>
								<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/>()) {
							
								<!-- test de présence dans le cache -->
								<xsl:value-of select="interface/name"/> oCache<xsl:value-of select="interface/name"/>
								<xsl:text>  = (</xsl:text><xsl:value-of select="interface/name"/>
								<xsl:text> ) p_oDaoSession.getFromCache( </xsl:text><xsl:value-of select="interface/name"/>
								<xsl:text>.ENTITY_NAME,	oEntity</xsl:text><xsl:value-of select="interface/name"/>
								<xsl:text>.getLoadMethod().getHelper().getCacheKeyOfEntity( oEntity</xsl:text>
								<xsl:value-of select="interface/name"/> ));
							
								if (oCache<xsl:value-of select="interface/name"/> == null) {
									<!-- si pas présent, on enregistre l'entité pour qu'elle soit chargée -->
									p_oCascadeOptim.registerEntityForCascadeUsingLoadMethod(<xsl:value-of select="$interface/name"/>
									<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
									<xsl:text>,	oEntity</xsl:text><xsl:value-of select="interface/name"/> );
								}
								else {
									<!-- si présent dans le cache, on la garde dans la liste pour la remplacer plus tard -->
									mapReplace.put(oCache<xsl:value-of select="interface/name"/>, oEntity<xsl:value-of select="interface/name"/>.getLoadMethod());
								}
								
								<!-- On effectue le remplacement -->
								for( Entry&lt;<xsl:value-of select="interface/name"/>,LoadMethod&gt; oEntry : mapReplace.entrySet()) {
									o<xsl:value-of select="$interface/name"/>.<xsl:value-of select="get-accessor"/>
									<xsl:text>().replace( oEntry.getKey(), oEntry.getValue());</xsl:text>
								}
							}
						</xsl:if>
					}
					
					</xsl:if>
				</xsl:for-each>
			}
		}</xsl:if>
	}
</xsl:template>

</xsl:stylesheet>