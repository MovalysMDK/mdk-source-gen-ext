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

<!-- Template permettant d'ajouter l'appel à la complétion de la Query avec l'HistorisationBlocMap
	pour les méthodes getObjectByPK(long id) en connaissant la valeur de la condition-->
<xsl:template name="dao-historisation-identifier">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	
	boolean bIsComplete = true;
	SqlQuery oLevelSqlQuery = new SqlQuery();
	<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
	<xsl:for-each select="class/identifier/descendant::attribute">
		<xsl:call-template name="dao-historisation-sql-addequalscondition-withvalue">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="queryObject">oLevelSqlQuery</xsl:with-param>
			<xsl:with-param name="fields" select="$pkFields"/>
			<xsl:with-param name="value" select="parameter-name"/>
		</xsl:call-template>
	</xsl:for-each>
	oLevelSqlQuery.addToFrom(this.getTableName(), HistorisationService.ALIAS_NAME);
	DaoQuery oLevelDaoQuery = new DaoQueryImpl(oLevelSqlQuery,this.getEntityName());
	<xsl:text>bIsComplete = this.completeQueryForEntityByPK(p_oDaoQuery, oLevelDaoQuery, p_oContext);
	if (bIsComplete){</xsl:text>
</xsl:template>

<!-- Template permettant d'ajouter l'appel à la complétion de la Query avec l'HistorisationBlocMap
	pour les méthodes getObjectByPK(long id) en connaissant l'object de la condition-->
<xsl:template name="dao-historisation-identifier-object">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	
	boolean bIsComplete = true;
	SqlQuery oLevelSqlQuery = new SqlQuery();
	<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
	<xsl:for-each select="class/identifier/descendant::attribute">
		<xsl:call-template name="dao-historisation-sql-addequalscondition-withvalue">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="queryObject">oLevelSqlQuery</xsl:with-param>
			<xsl:with-param name="fields" select="$pkFields"/>
			<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	oLevelSqlQuery.addToFrom(this.getTableName(), HistorisationService.ALIAS_NAME);
	DaoQuery oLevelDaoQuery = new DaoQueryImpl(oLevelSqlQuery,this.getEntityName());

	<xsl:text>bIsComplete = this.completeQueryForEntityByPK(oQuery, oLevelDaoQuery, p_oContext);
	if (bIsComplete){</xsl:text>
</xsl:template>

<!-- Template permettant d'ajouter l'appel à la complétion de la Query avec l'HistorisationBlocMap
	pour les méthodes getObjectByPK(Object oObject)-->
<xsl:template name="dao-historisation-method-parameter">
	<xsl:param name="interface"/>
	<xsl:param name="method-parameter"/>
	<xsl:text>boolean bIsComplete = true;</xsl:text>
	<xsl:text>bIsComplete = this.completeQueryForBy(p_oDaoQuery</xsl:text>
<!-- 	<xsl:if test="not($method-parameter/@by-value = 'true')"> -->
		<xsl:for-each select="method-parameter">
			<xsl:if test="not(@by-value = 'true')">
				<xsl:text>, </xsl:text><xsl:value-of select="@name"/>
			</xsl:if>
		</xsl:for-each>
<!-- 	</xsl:if>-->
	<xsl:text>);</xsl:text>
	<xsl:text>
	if (bIsComplete){</xsl:text>
</xsl:template>

<!-- Template permettant d'ajouter l'appel à la complétion de la Query avec l'HistorisationBlocMap
	pour les méthodes getList(), getNb() -->
<xsl:template name="dao-historisation-whithout-parameter">
	<xsl:param name="interface"/>
	<xsl:text>boolean bIsComplete = this.completeQueryForList(p_oDaoQuery);</xsl:text>
	<xsl:text>if (bIsComplete){</xsl:text>
</xsl:template>

<!-- Template permettant de créer la requête de sélection des object pour l'historisation -->
<xsl:template name="dao-historisation-sql-addequalscondition-withvalue">
	<xsl:param name="interface"/>
	<xsl:param name="queryObject"/>
	<xsl:param name="object"/>
	<xsl:param name="fields"/>
	<xsl:param name="value"/>

	<xsl:variable name="position" select="position()"/>
	<xsl:variable name="field" select="$fields[position() = $position]"/>
	
	<xsl:value-of select="$queryObject"/><xsl:text>.addFieldToSelect(HistorisationService.ALIAS_NAME,</xsl:text>
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/dao-interface/name"/><xsl:text>.</xsl:text>
		<xsl:value-of select="$field/ancestor::association/join-table/interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:value-of select="$field/@name"/>
	<xsl:text>);
	</xsl:text>
	
	<xsl:value-of select="$queryObject"/><xsl:text>.addEqualsConditionToWhere(</xsl:text>
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/dao-interface/name"/><xsl:text>.</xsl:text>
		<xsl:value-of select="$field/ancestor::association/join-table/interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	
	<xsl:value-of select="$field/@name"/><xsl:text>, HistorisationService.ALIAS_NAME, </xsl:text>
	<xsl:if test="$object">
		<xsl:if test="parent::class or parent::identifier"><xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/></xsl:if>
		<xsl:if test="parent::association"><xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/></xsl:if>
		<xsl:text>()</xsl:text>
	</xsl:if>
	<xsl:if test="$value"><xsl:value-of select="$value"/></xsl:if>
	<xsl:text>, SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/><xsl:text>);</xsl:text>
</xsl:template>

<!-- Template permettant de terminer les traitements de l'historisation (fermeture balise if) -->
<xsl:template name="dao-historisation-end">
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- Template permettant de récupérer le niveau du bloc d'historisation dans la méthode valueObject() -->
<xsl:template name="dao-historisation-valueobject-single-begin">
	((DaoQueryImpl)p_oDaoQuery).getQueryHistorisationBlocMap().put(this.getHistorisationBlocType(), 
		this.getHelperHistorisationBlocLevel().retreiveHistorisationEntityLevelType(p_oResultSetReader.getHistoLevel()).getHistorisationEntityLevelTypeSet());
	this.simplifyQueryHistorisationBlocMap(p_oDaoQuery);
</xsl:template>

<!-- Template permettant d'affecter ou non les paramètres à la Query -->
<xsl:template name="dao-historisation-set-query-parameter">
	<xsl:text>if(this.getHistorisationBlocType().isStaticBloc()){
		oDaoQuery.setHistorisationQueryLevelType(p_oDaoQuery.getHistorisationQueryLevelType());
		oDaoQuery.setHistorisationQueryMinDate(p_oDaoQuery.getHistorisationQueryMinDate());
	}</xsl:text>
</xsl:template>

<!-- Template permettant d'affecter l'HistorisationBlocMap à la Query de la cascade dans la methode ValueObject -->
<xsl:template name="dao-historisation-valueobject-single-set-query-cascade">
	((DaoQueryImpl)oDaoQuery).setQueryHistorisationBlocMap(((DaoQueryImpl)p_oDaoQuery).getQueryHistorisationBlocMap());
	<xsl:call-template name="dao-historisation-set-query-parameter"/>
</xsl:template>

<!-- Template permettant d'affecter l'HistorisationBlocMap de la Query de la cascade à la Query principale dans la methode ValueObject -->
<xsl:template name="dao-historisation-valueobject-single-get-query-cascade">
	if(this.getHistorisationBlocType().isWithCascade()){
		((DaoQueryImpl)p_oDaoQuery).setQueryHistorisationBlocMap(((DaoQueryImpl)oDaoQuery).getQueryHistorisationBlocMap());
	}
</xsl:template>

<!-- Template permettant d'affecter l'EntityHistorisationBlocMap à l'entité dans la methode ValueObject -->
<xsl:template name="dao-historisation-valueobject-single-end">
	<xsl:param name="interfaceName"/>
	<xsl:text>((AbstractBOPersistableEntity)</xsl:text><xsl:value-of select="$interfaceName"/><xsl:text>).setEntityHistorisationBlocMap(this.transformQueryBlocMapToEntityBlocMap(</xsl:text><xsl:value-of select="$interfaceName"/><xsl:text>,((DaoQueryImpl)p_oDaoQuery).getQueryHistorisationBlocMap()));
	</xsl:text>
</xsl:template>

<!-- Template permettant d'affecter la QueryHistorisationBlocMap à la Query provenant de l'EntityHistorisationBlocMap -->
<xsl:template name="dao-historisation-getX-single-set-query">
	<xsl:param name="interface"/>
	<xsl:text>((DaoQueryImpl)p_oDaoQuery).setQueryHistorisationBlocMap(this.transformEntityBlocMapToQueryBlocMap(((AbstractBOPersistableEntity)</xsl:text>p_o<xsl:value-of select="$interface/name"/><xsl:text>).getEntityHistorisationBlocMap()));</xsl:text>
</xsl:template>

<!-- Template permettant d'affecter la QueryHistorisationBlocMap à la Query de la cascade dans la méthode postTraitementCascade()-->
<xsl:template name="dao-historisation-postTraitementCascade-set-query-cascade">
	<xsl:text>((DaoQueryImpl)oDaoQuery).setQueryHistorisationBlocMap(((DaoQueryImpl)p_oDaoQuery).getQueryHistorisationBlocMap());</xsl:text>
	<xsl:call-template name="dao-historisation-set-query-parameter"/>
</xsl:template>

<!-- Template permettant de mettre à jour la QyeryHistorisationBlocMap en fonction de l'EntityHistorisationBlocMap d'une entité dans la méthode postTraitementCascade() -->
<xsl:template name="dao-historisation-postTraitementCascade-get-map-entity-cascade">
	<xsl:param name="masterEntityName"/>
	<xsl:param name="cascadeDaoName"/>
	<xsl:param name="cascadeEntityName"/>
	if(this.getHistorisationBlocType().isWithCascade()){
		EntityHistorisationBlocMap oEntityHistorisationBlocMap = <xsl:value-of select="$masterEntityName"/>.getEntityHistorisationBlocMap();
		if (<xsl:value-of select="$cascadeEntityName"/> != null) {
			for (Map.Entry&lt;HistorisationBlocType, HistorisationEntityLevelType&gt; oEntry : <xsl:value-of select="$cascadeEntityName"/>.getEntityHistorisationBlocMap().entrySet()) {
				HistorisationEntityLevelType oEntryValue = oEntry.getValue();
				if(oEntryValue.isPreciseSearch()){
					if(oEntityHistorisationBlocMap.get(oEntry.getKey()).isPreciseSearch() <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text>
						!oEntityHistorisationBlocMap.get(oEntry.getKey()).equals(oEntry.getValue())){
						log.error(" oEntityHistorisationBlocMap.get(oEntry.getKey()) = {}", oEntityHistorisationBlocMap.get(oEntry.getKey()));
						log.error(" oEntry.getValue() = {}", oEntry.getValue());
						log.error(" Erreur de données lors de la récupération des données d'historisation.");
						log.error(" Le niveau récupéré ({}) n'est pas le même que celui déjà défini ({}).", 
							oEntry.getValue(), oEntityHistorisationBlocMap.get(oEntry.getKey()) ); 
						log.error("stacktrace: ", new Throwable());
						throw new RuntimeException(" Erreur de données lors de la récupération des données d'historisation..");
					}
					oEntityHistorisationBlocMap.put(oEntry.getKey(), oEntry.getValue());
				}
			}
		}
	}
</xsl:template>

<!-- Template permettant de mettre à jour la QyeryHistorisationBlocMap en fonction de l'EntityHistorisationBlocMap d'une entité dans la méthode postTraitementFillCascade() -->
<xsl:template name="dao-historisation-postTraitementFillCascade-get-map-entity-cascade">
	<xsl:param name="masterEntityName"/>
	<xsl:param name="cascadeDaoName"/>
	<xsl:param name="cascadeEntityName"/>
	<xsl:text>if(this.getHistorisationBlocType().isWithCascade()){
		for (Object oObject : (Collection&lt;Object&gt;) p_oCascadeOptim.getListMainEntity()) {
			</xsl:text><xsl:value-of select="$masterEntityName"/><xsl:text> oEntity</xsl:text><xsl:value-of select="$masterEntityName"/><xsl:text> = (</xsl:text><xsl:value-of select="$masterEntityName"/><xsl:text>) oObject;
		</xsl:text><xsl:call-template name="dao-historisation-postTraitementCascade-get-map-entity-cascade">
			<xsl:with-param name="masterEntityName">oEntity<xsl:value-of select="$masterEntityName"/></xsl:with-param>
			<xsl:with-param name="cascadeDaoName"><xsl:value-of select="$cascadeDaoName"/></xsl:with-param>
			<xsl:with-param name="cascadeEntityName">oEntity<xsl:value-of select="$cascadeEntityName"/></xsl:with-param>
		</xsl:call-template><xsl:text>
		}
	}
	</xsl:text>
</xsl:template>

<!-- Template permettant de mettre à jour la QyeryHistorisationBlocMap en fonction des EntityHistorisationBlocMap de la liste d'entités dans la méthode postTraitementCascade() -->
<xsl:template name="dao-historisation-postTraitementCascade-get-map-list-cascade">
	<xsl:param name="masterEntity"/>
	<xsl:param name="cascadeEntity"/>
	<xsl:text>if(this.getHistorisationBlocType().isWithCascade()){
		for (Object oObject : (Collection&lt;Object&gt;) p_oCascadeOptim.getListMainEntity()) {
			</xsl:text><xsl:value-of select="$masterEntity/name"/> oEntity<xsl:value-of select="$masterEntity/name"/><xsl:text> = (</xsl:text><xsl:value-of select="$masterEntity/name"/><xsl:text>) oObject;
			</xsl:text>BOList&lt;<xsl:value-of select="$cascadeEntity/name"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="variable-name"/><xsl:text> = </xsl:text>
			<xsl:text>oEntity</xsl:text><xsl:value-of select="$masterEntity/name"/><xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>();
			Map&lt;HistorisationBlocType, Set&lt;HistorisationEntityLevelType&gt;&gt; listHistoMap = new HashMap&lt;HistorisationBlocType, Set&lt;HistorisationEntityLevelType&gt;&gt;();
			for (</xsl:text><xsl:value-of select="$cascadeEntity/name"/><xsl:text> oFor</xsl:text><xsl:value-of select="$cascadeEntity/name"/><xsl:text> : </xsl:text><xsl:value-of select="variable-name"/><xsl:text>) {
				for (Map.Entry&lt;HistorisationBlocType, HistorisationEntityLevelType&gt; oEntry : oFor</xsl:text><xsl:value-of select="$cascadeEntity/name"/><xsl:text>.getEntityHistorisationBlocMap().entrySet()) {
					if(oEntry.getValue().isPreciseSearch()){
						Set&lt;HistorisationEntityLevelType&gt; setHistorisationEntityLevelType = listHistoMap.get(oEntry.getKey());
						if(setHistorisationEntityLevelType==null){
							setHistorisationEntityLevelType = new TreeSet&lt;HistorisationEntityLevelType&gt;();
						}
						setHistorisationEntityLevelType.add(oEntry.getValue());
						listHistoMap.put(oEntry.getKey(), setHistorisationEntityLevelType);
					}
				}
			}
			EntityHistorisationBlocMap oEntityHistorisationBlocMap = oEntity</xsl:text><xsl:value-of select="$masterEntity/name"/><xsl:text>.getEntityHistorisationBlocMap();
			for (Map.Entry&lt;HistorisationBlocType, Set&lt;HistorisationEntityLevelType&gt;&gt; oEntry : listHistoMap.entrySet()) {
				if(oEntry.getValue().size()==1){
					oEntityHistorisationBlocMap.put(oEntry.getKey(), (HistorisationEntityLevelType)oEntry.getValue().toArray()[0]);
				}else{
					log.error(" La liste a plus d'un élémént ");
					log.error(" </xsl:text><xsl:value-of select="$masterEntity/name"/><xsl:text> : {}", oEntity</xsl:text><xsl:value-of select="$masterEntity/name"/><xsl:text>.idToString());
					log.error(" oEntry.getKey() = {}", oEntry.getKey());
					log.error(" oEntry.getValue() = {}", oEntry.getValue());
					log.error(" Erreur de données lors de la récupération des données d'historisation.");
					log.error("stacktrace: ", new Throwable());
					throw new RuntimeException(" Erreur de données lors de la récupération des données d'historisation..");
				}
			}
		}
	}</xsl:text>
</xsl:template>

</xsl:stylesheet>