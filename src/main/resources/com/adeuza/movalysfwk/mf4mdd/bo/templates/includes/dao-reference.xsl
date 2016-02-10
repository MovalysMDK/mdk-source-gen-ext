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


<!-- Cascade REFERENCES : chargement de toutes les références d'un entity -->
<xsl:template name="dao-reference-cascade-get-references">
	<xsl:param name="interface"/>

	<!-- References -->
	if (p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.REFERENCES)
			|| p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL_REFERENCES)) {

		r_o<xsl:value-of select="$interface/name"/>.addAllReferences(this.referenceDao.getListReference_By_MiEntityId(
			r_o<xsl:value-of select="$interface/name"/>
				<xsl:text>.idToString(),</xsl:text> 
				<xsl:value-of select="$interface/name"/>.ENTITY_NAME, p_oDaoSession, p_oContext));
	}

</xsl:template>

<!-- Cascade REFERENCES : chargement optimisée des références d'une liste d'entity -->
<xsl:template name="dao-reference-cascade-getlist-references">
	<xsl:param name="interface"/>

	<!-- References -->
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/><xsl:text>.Cascade.REFERENCES ) || </xsl:text>
			<xsl:text> p_oCascadeSet.contains( CascadeSet.GenericCascade.ALL_REFERENCES )) {
		</xsl:text>
			DaoQuery oQuery = this.referenceDao.getSelectDaoQuery();
			oSqlInValueCondition.setField(ReferenceDao.ReferenceField.IDMOVALYS.name(), ReferenceDao.ALIAS_NAME, SqlType.VARCHAR);
			oQuery.getSqlQuery().addToWhere(oSqlInValueCondition);
			
			<xsl:text>ListReferences listReferences = this.referenceDao.getListReference(oQuery, </xsl:text>
			<xsl:value-of select="$interface/name"/>
			<xsl:text>.ENTITY_NAME, p_oDaoSession, p_oContext);</xsl:text>
			
			for( Reference oReference : listReferences ) {
				<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/>
				<xsl:text> = (</xsl:text><xsl:value-of select="$interface/name"/>
				<xsl:text>) p_oCascadeOptim.getEntity( oReference.getMiEntityId());</xsl:text>
				o<xsl:value-of select="$interface/name"/>.addReference( oReference );
			}
		}
</xsl:template>

<!-- Cascade REFERENCES : Sauvegarde des références dans le cadre du save or update -->
<xsl:template name="dao-reference-after-saveorupdate">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	<xsl:param name="object"/>
	<xsl:param name="traitement-list" select="'false'"/>
		
<xsl:if test="count($class/attribute[@name='admLastModificationDate']) = 1 and count($class/attribute[@name='admVersion']) = 1">

	<!-- Traitement des références -->
	if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/><xsl:text>.Cascade.REFERENCES ) || </xsl:text>
			<xsl:text> p_oCascadeSet.contains( CascadeSet.GenericCascade.ALL_REFERENCES )) {</xsl:text>
		ListReferences listReferencesToUpdate = new ListReferences();
		
		<xsl:if test="$traitement-list = 'true'">
		for (<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : <xsl:value-of select="$object"/>) {
			for( Reference oReference : o<xsl:value-of select="$interface/name"/>.getReferences()) {
				if ( p_oContext.getUserProfile().getExtSiId() == oReference.getExtSiId()) {
					oReference.setMiEntityId(o<xsl:value-of select="$interface/name"/>.idToString());
					oReference.setMiEntityVersion(o<xsl:value-of select="$interface/name"/>.getAdmVersion());
					oReference.setLastModifDate(new Date(o<xsl:value-of select="$interface/name"/>.getAdmLastModificationDate().getTime()));
					oReference.setExtSiEntityVersion(o<xsl:value-of select="$interface/name"/>.getAdmVersion());
					listReferencesToUpdate.addReference(oReference);
				}
			}
		}
		</xsl:if>		
		
		<xsl:if test="$traitement-list = 'false'">
		for( Reference oReference : p_o<xsl:value-of select="$interface/name"/>.getReferences()) {
			if ( p_oContext.getUserProfile().getExtSiId() == oReference.getExtSiId()) {
				oReference.setMiEntityId(p_o<xsl:value-of select="$interface/name"/>.idToString());
				oReference.setMiEntityVersion(p_o<xsl:value-of select="$interface/name"/>.getAdmVersion());
				oReference.setLastModifDate(new Date(p_o<xsl:value-of select="$interface/name"/>.getAdmLastModificationDate().getTime()));
				oReference.setExtSiEntityVersion(p_o<xsl:value-of select="$interface/name"/>.getAdmVersion());
				listReferencesToUpdate.addReference(oReference);
			}
		}
		</xsl:if>
		
		this.referenceDao.saveOrUpdate( listReferencesToUpdate, <xsl:value-of select="$interface/name"/>.ENTITY_NAME, p_oContext);
	}
	</xsl:if>

</xsl:template>

<!-- Sauvegarde avec l'id de reference : pré-étape dans le cas : l'entity n'a que l'id de référence de renseigné, il
faut retrouver l'id movalys correspondant avec la sauvegarde -->
<xsl:template name="dao-reference-loadbyreference-beforesave">

	<!-- On regarde dans les references passees s'il n'y a pas l'id movalys -->
	List&lt;String&gt; listExternalIds = new ArrayList&lt;String&gt;();
	Iterator&lt;Reference&gt; iterReferences = p_o<xsl:value-of select="interface/name"/>.getReferences().iterator();
	Reference oReference = null ;
	while( iterReferences.hasNext()) {
		oReference = iterReferences.next();
		<!-- si non charge ou nouvelle -->
		if ( oReference.getMiEntityId() == null ) {
			listExternalIds.add(oReference.getExtSiEntityId());
		} else {
			p_o<xsl:value-of select="interface/name"/>.setId(Long.parseLong(oReference.getMiEntityId()));
		}
	}
				
	ListReferences listReferences = new ListReferences(); 
				
	<!-- Si toujours pas d'id, on tente un chargement par les code externes -->
	if ( p_o<xsl:value-of select="interface/name"/>.getId() &lt; 0 ) {
		listReferences.addAll(this.referenceDao.getListReference_By_ExtSiId_ExtSiEntityIds(
			oReference.getExtSiId(), listExternalIds, <xsl:value-of select="interface/name"/>.ENTITY_NAME, new DaoSession(), p_oContext ));
		if ( !listReferences.isEmpty() ) {
			p_o<xsl:value-of select="interface/name"/>.setId(Long.parseLong(listReferences.iterator().next().getMiEntityId()));
		}
	}
				
	<!-- Merge des references passees en parametre avec les references en base -->
	for( Reference oRef : p_o<xsl:value-of select="interface/name"/>.getReferences()) {
		boolean bTrouve = false ;
		Iterator&lt;Reference&gt; iterReference = listReferences.iterator();
		while( iterReference.hasNext() &amp;&amp; !bTrouve) {
			Reference oDbReference = iterReference.next();
			bTrouve = oRef.getExtSiEntityId().equals(oDbReference.getExtSiEntityId());
		}
		<!--  Si non trouve, c'est une nouvelle reference -->
		if ( !bTrouve ) {
			listReferences.addReference(oRef);
		}
	}
	p_o<xsl:value-of select="interface/name"/>.getReferences().clear();
	p_o<xsl:value-of select="interface/name"/>.addAllReferences(listReferences);

</xsl:template>

<!-- Sauvegarde de liste avec l'id de reference : pré-étape dans le cas : l'entity n'a que l'id de référence de renseigné, il
faut retrouver l'id movalys correspondant avec la sauvegarde -->
<xsl:template name="dao-reference-loadlistbyreference-beforesave">

	List&lt;String&gt; listExternalIds = new ArrayList&lt;String>();
	Map&lt;String,<xsl:value-of select="interface/name"/>&gt; map<xsl:value-of select="interface/name"/> = new HashMap&lt;String,<xsl:value-of select="interface/name"/>&gt;();
	long lExtSiId = -1 ;
	for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/> : listSave) {
		<!-- Si présence de référence -->
		if ( !o<xsl:value-of select="interface/name"/>.getReferences().isEmpty() ) {

			<!-- Recherche de l'id movalys parmis la liste de référence -->
			Iterator&lt;Reference&gt; iterReferences = o<xsl:value-of select="interface/name"/>.getReferences().iterator();
			Reference oReference = null;
			while (iterReferences.hasNext()) {
				oReference = iterReferences.next();

				if (oReference.getMiEntityId() == null) {
					<!-- stocke la liste des id externes -->
					listExternalIds.add(oReference.getExtSiEntityId());
					map<xsl:value-of select="interface/name"/>.put(oReference.getExtSiEntityId(), o<xsl:value-of select="interface/name"/>);
					lExtSiId = oReference.getExtSiId();
				} else {
					o<xsl:value-of select="interface/name"/>.setId(Long.parseLong(oReference.getMiEntityId()));
				}
			}
		}
	}
		
	if ( !listExternalIds.isEmpty() &amp;&amp; lExtSiId != -1 ) {
		
		<!-- Chargement des références non chargées -->
		ListReferences listAllReferences = this.referenceDao.getListReference_By_ExtSiId_ExtSiEntityIds(
			lExtSiId, listExternalIds, <xsl:value-of select="interface/name"/>.ENTITY_NAME, new DaoSession(),
			p_oContext );
			
		if ( listAllReferences != null ) {	
		
			<!--  Pour chacune -->
			for( Reference oReference : listAllReferences ) {
					<!--  retrouve la ressource correspondance -->
					<xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/> = map<xsl:value-of select="interface/name"/>.get(oReference.getExtSiEntityId());
					<!--  affecte l'id -->
					o<xsl:value-of select="interface/name"/>.setId(Long.parseLong(oReference.getMiEntityId()));
				
					<!--  On a trouvé son id, la ressource doit être mise à jour et pas updaté -->
					listSave.remove(o<xsl:value-of select="interface/name"/>);
					listUpdate.add(o<xsl:value-of select="interface/name"/>);
				
					<!--  reconstruit la liste des références de la resource -->
					boolean bTrouve = false ;
					Iterator&lt;Reference&gt; iterRessourceRefs = o<xsl:value-of select="interface/name"/>.getReferences().iterator(); 
					while( iterRessourceRefs.hasNext() &amp;&amp; !bTrouve ) {
						Reference oRef = (Reference) iterRessourceRefs.next();
						if ( oRef.getExtSiEntityId().equals(oReference.getExtSiEntityId())) {
							bTrouve = true ;
							oRef.setId(oReference.getId());
							oRef.setState(oReference.getState());
							oRef.setValidity(oReference.getValidity());
							oRef.setLastModifDate(oReference.getLastModifDate());
							oRef.setExtSiEntityVersion(oReference.getExtSiEntityVersion());
							oRef.setMiEntityId(o<xsl:value-of select="interface/name"/>.idToString());
							oRef.setMiEntityVersion(o<xsl:value-of select="interface/name"/>.getAdmVersion());
						}
					}
				}
			}
		}
</xsl:template>

<xsl:template name="dao-reference-updatereference-afterexport">

	<xsl:if test="count(class/attribute[@name='admLastModificationDate']) = 1 and count(class/attribute[@name='admVersion']) = 1">

	if ( p_oDaoQuery.getExportExtSiFilter() != -1 ) {
		ListReferences listReferences = new ListReferences();
		Date oModifDate = new Date(System.currentTimeMillis());
		for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/> : r_list<xsl:value-of select="interface/name"/> ) {
			<!-- Crée une référence pour les entity sans référence -->
			if ( o<xsl:value-of select="interface/name"/>.getReferences().isEmpty()) {
				Reference oReference = new Reference();
				oReference.setExtSiId(p_oDaoQuery.getExportExtSiFilter());
				oReference.setExtSiEntityId("0");
				oReference.setExtSiEntityVersion(o<xsl:value-of select="interface/name"/>.getAdmVersion());
				oReference.setMiEntityId(o<xsl:value-of select="interface/name"/>.idToString());
				oReference.setMiEntityVersion(o<xsl:value-of select="interface/name"/>.getAdmVersion());
				oReference.setLastModifDate(oModifDate);
				o<xsl:value-of select="interface/name"/>.addReference(oReference);
				listReferences.addReference(oReference);
			}
			<!-- Met à jour les références existantes --> 
			else {
				for( Reference oReference : o<xsl:value-of select="interface/name"/>.getReferences()) {
					oReference.setLastModifDate(oModifDate);
					oReference.setExtSiEntityVersion(o<xsl:value-of select="interface/name"/>.getAdmVersion());
					listReferences.addReference(oReference);
				}
			}
		}
		this.referenceDao.saveOrUpdate(listReferences, <xsl:value-of select="interface/name"/>.ENTITY_NAME, p_oContext);
	}
	</xsl:if>
	
</xsl:template>

<!-- Sur un LEFT OUTER JOIN avec la table de Reference, permet de lire la partie ResultSet de la table Reference -->
<xsl:template name="dao-reference-readresultset-reference">
	<xsl:param name="class"/>

	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']) > 0 ">

	if (p_oDaoQuery.getExportExtSiFilter() != -1) {
		p_oDaoQuery.addRowReaderCallBack( new ReferenceRowReaderCallBack());
	}
	
	</xsl:if>
	
</xsl:template>

</xsl:stylesheet>