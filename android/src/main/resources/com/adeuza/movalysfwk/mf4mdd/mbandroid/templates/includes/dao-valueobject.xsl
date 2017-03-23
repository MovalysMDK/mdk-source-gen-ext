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
	<xsl:template match="dao" mode="value-object">
		<xsl:variable name="interface" select="interface"/>
		<xsl:variable name="class" select="class"/>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Returns an instance of a </xsl:text><xsl:value-of select="interface/name"/><xsl:text> object from a given ResultSetReader</xsl:text>
		<xsl:text>	 * @param p_oResultSetReader résultat de la requête&#13;</xsl:text>
		<xsl:text>	 * @param p_oDaoQuery requête&#13;</xsl:text>
		<xsl:text>	 * @param p_oDaoSession session Dao&#13;</xsl:text>
		<xsl:text>	 * @param p_oCascadeSet ensemble de Cascades sur les entités&#13;</xsl:text>
		<xsl:text>	 * @param p_oContext contexte transactionnel&#13;</xsl:text>
		<xsl:text>	 * @return l'entité </xsl:text><xsl:value-of select="interface/name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 * @throws DaoException déclenchée si une exception technique survient&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	protected </xsl:text><xsl:value-of select="interface/name"/><xsl:text> valueObject( ResultSetReader p_oResultSetReader, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession,&#13;</xsl:text>
		<xsl:text>			CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {&#13;&#13;</xsl:text>

		<xsl:text>		</xsl:text><xsl:value-of select="interface/name"/> r_o<xsl:value-of select="interface/name"/><xsl:text> = this.</xsl:text><xsl:value-of select="class/pojo-factory-interface/bean-name"/><xsl:text>.createInstance();&#13;</xsl:text>

		<!-- Traite d'abord la clé primaire (sans faire les cascades)-->
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="jdbc-retrieve-pk-firstpass">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:apply-templates select="." mode="value-object-get-from-cache"/>

		<!-- Traitement des cascades sur la clé primaire -->
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="jdbc-retrieve-pk-secondpass">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="optimList" select="'false'"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<!-- Initialisation des OldId -->
		<xsl:call-template name="initializeOldId">
			<xsl:with-param name="varEntity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>

		<!-- Traite ensuite les autre champs
			attribut non transient
			attribut non identifier
			attribut simple ou attribut d'association non transiente
		-->
		<xsl:for-each select="class/descendant::attribute[@transient = 'false' and not(ancestor::identifier) and (not(parent::association) or (parent::association and ../@transient='false'))]">
			<xsl:call-template name="jdbc-retrieve">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="optimList" select="'false'"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<!-- Traite les cascades vers n -->
		<xsl:for-each select="class/association[@transient = 'false' and (@type='one-to-many' or @type='many-to-many' or (@type='one-to-one' and @relation-owner='false')) and not(parent::association)]">
			<xsl:text>			if ( p_oCascadeSet.contains(</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text>)) {&#13;</xsl:text>
				<xsl:text>DaoQuery oDaoQuery = </xsl:text>
				<xsl:if test="@self-ref = 'false'">
					<xsl:text>this.</xsl:text>
					<xsl:value-of select="dao-interface/bean-ref"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:text>getSelectDaoQuery();</xsl:text>
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
				}
			</xsl:for-each>

			<xsl:if test="class[customizable='true']">
				if (p_oCascadeSet.contains(CascadeSet.GenericCascade.CUSTOM_FIELDS) || p_oCascadeSet.contains(<xsl:value-of select="class/implements/interface/@name"/>Cascade.CUSTOM_FIELDS)) {
					Collection&lt;CustomField&gt; listCustomFields = this.customFieldDao.getListCustomFieldOf(r_o<xsl:value-of select="interface/name"/>, p_oContext);
					for (CustomField oCustomField : listCustomFields) {
						r_o<xsl:value-of select="interface/name"/>.setCustomField(oCustomField.getFieldName(), oCustomField.getStrValues());
					}
				}
			</xsl:if>

<!-- 			<xsl:call-template name="dao-reference-cascade-get-references">
				<xsl:with-param name="interface" select="$interface"/>
			</xsl:call-template> -->
		<xsl:text>}
		else {
			r_o</xsl:text>
			<xsl:value-of select="interface/name"/> = oCached<xsl:value-of select="interface/name"/> ;
		}

		<xsl:call-template name="dao-value-object-readextraresultset">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="entity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>

		return r_o<xsl:value-of select="interface/name"/> ;
	}
	
</xsl:template>




	<!-- Value un objet à partir du ResultSet en utilisant la méthode optimisée pour les listes -->
	<xsl:template match="dao" mode="value-object-optim-list">
		<xsl:param name="interface" select="interface"/>
		<xsl:param name="class" select="class"/>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Returns an instance of a </xsl:text><xsl:value-of select="interface/name"/><xsl:text> object from a given ResultSetReader</xsl:text>
		<xsl:text>	 * @param p_oResultSetReader reader de resultset&#13;</xsl:text>
		<xsl:text>	 * @param p_oDaoQuery requête&#13;</xsl:text>
		<xsl:text>	 * @param p_oDaoSession session Dao&#13;</xsl:text>
		<xsl:text>	 * @param p_oCascadeSet ensemble de Cascades sur les entités&#13;</xsl:text>
		<xsl:text>	 * @param p_oCascadeOptim optimiseur de l'éxécution des cascades&#13;</xsl:text>
		<xsl:text>	 * @param p_oContext contexte transactionnel&#13;</xsl:text>
		<xsl:text>	 * @throws DaoException déclenchée si une exception technique survient&#13;</xsl:text>
		<xsl:text>	 * @return l'entité </xsl:text><xsl:value-of select="interface/name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	protected </xsl:text><xsl:value-of select="interface/name"/><xsl:text> valueObject( ResultSetReader p_oResultSetReader, DaoQuery p_oDaoQuery, DaoSession p_oDaoSession,&#13;</xsl:text>
		<xsl:text>			CascadeSet p_oCascadeSet, CascadeOptim p_oCascadeOptim, MContext p_oContext ) throws DaoException {&#13;&#13;</xsl:text>
		
		<xsl:value-of select="interface/name"/> r_o<xsl:value-of select="interface/name"/> = this.<xsl:value-of select="class/pojo-factory-interface/bean-name"/>.createInstance();

		<!-- Traite d'abord la clé primaire (sans faire les cascades)-->
		<xsl:for-each select="class/identifier/descendant::attribute">
			<xsl:call-template name="jdbc-retrieve-pk-firstpass">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="resultSet">p_oResultSetReader</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		String sEntityId = r_o<xsl:value-of select="interface/name"/>.idToString();
		<xsl:apply-templates select="." mode="value-object-get-from-cache">
			<xsl:with-param name="hasVariableEntityId" select="'true'"/>
		</xsl:apply-templates>

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
			
			<xsl:call-template name="initializeOldId">
				<xsl:with-param name="varEntity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
			</xsl:call-template>

			<!-- Traite ensuite les autre champs -->
			<xsl:for-each select="class/descendant::attribute[@transient = 'false' and not(ancestor::identifier) and (not(parent::association) or (parent::association and ../@transient='false'))]">
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
		}
		
		<xsl:call-template name="dao-value-object-readextraresultset">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="entity">r_o<xsl:value-of select="interface/name"/></xsl:with-param>
		</xsl:call-template>
		
		return r_o<xsl:value-of select="interface/name"/> ;
	}
	
</xsl:template>

	<!-- Essaie de récupérer l'entité dans le cache après avoir lu sa clé primaire dans le résultset. -->
	<xsl:template match="dao" mode="value-object-get-from-cache">
		<xsl:param name="hasVariableEntityId">false</xsl:param>

		<xsl:if test="$hasVariableEntityId = 'false'">
			<xsl:text>		String sEntityId = r_o</xsl:text><xsl:value-of select="interface/name"/><xsl:text>.idToString();&#13;</xsl:text>
		</xsl:if>

		<xsl:value-of select="interface/name"/>
		<xsl:text> oCached</xsl:text>
		<xsl:value-of select="interface/name"/>
		<xsl:text> = (</xsl:text>
		<xsl:value-of select="interface/name"/>
		<xsl:text>) p_oDaoSession.getFromCache(</xsl:text>
		<xsl:value-of select="interface/name"/>
		<xsl:text>.ENTITY_NAME, </xsl:text>

		<xsl:text> sEntityId );</xsl:text>

		<xsl:text>		if ( oCached</xsl:text><xsl:value-of select="interface/name"/><xsl:text> == null ) {&#13;</xsl:text>
		<xsl:text>			p_oDaoSession.addToCache(</xsl:text><xsl:value-of select="interface/name"/>
		<xsl:text>.ENTITY_NAME, sEntityId, r_o</xsl:text>
		<xsl:value-of select="interface/name"/><xsl:text> );&#13;</xsl:text>
	</xsl:template>


<xsl:template name="dao-value-object-readextraresultset">
	<xsl:param name="class"/>
	<xsl:param name="interface"/>
	<xsl:param name="entity"/>

	<xsl:variable name="attrs" select="$class/descendant::attribute[(not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]"/>
	<xsl:variable name="pos" select="$attrs[last()]/@pos"/>
	p_oDaoQuery.doResultSetCustomRead( <xsl:value-of select="$entity"/>, p_oResultSetReader, p_oDaoSession, p_oCascadeSet);
</xsl:template>


<!-- Initialisation des OldId -->
<xsl:template name="initializeOldId">
	<xsl:param name="varEntity"/>
			
	<xsl:if test="class/parameters/parameter[@name='oldidholder'] = 'true'">
		<xsl:value-of select="$varEntity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="class/attribute[parameters/parameter[@name='oldidholder'] = 'true']/set-accessor"/>
		<xsl:text>( </xsl:text><xsl:value-of select="$varEntity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="class/identifier/attribute/get-accessor"/>
		<xsl:text>());</xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
