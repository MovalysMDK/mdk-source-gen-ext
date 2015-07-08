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

<xsl:template match="dao" mode="sql-queries">
	<xsl:variable name="interface" select="interface"/>
	
	/**
	 * Requête de sélection des entités
	 */
	private SqlQuery selectQuery ;

	<xsl:if test="count(class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
	/**
	  * Requête de sélection des identifiants
	  */
	private SqlQuery selectIdQuery ;
	</xsl:if>
	
	/**
	 * Requête de comptage
	 */
	private SqlQuery countQuery ;

	/**
	 * Requête d'insertion
	 */
	private SqlInsert insertQuery ;

	/**
	 * Requête d'update
	 */
	private SqlUpdate updateQuery ;

	/**
	 * Requête de suppression.
	 */
	private SqlDelete deleteQuery ;

</xsl:template>

<xsl:template match="dao" mode="sql-queries-initialize">
	<xsl:variable name="interface" select="interface"/>

	<!--  select query -->
	selectQuery = new SqlQuery();
	<xsl:text>selectQuery.addFieldToSelect(</xsl:text>
	<xsl:value-of select="dao-interface/name"/>.ALIAS_NAME, 
	<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute[@transient='false']/field | class/association/field | class/attribute//properties/property/field">
		<xsl:value-of select="$interface/name"/>
		<xsl:text>Field.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>);</xsl:text>
	selectQuery.addToFrom( <xsl:value-of select="dao-interface/name"/>.TABLE_NAME, <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME );

	<!--  select id query -->
	<xsl:if test="count(class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
	selectIdQuery = new SqlQuery();
	<xsl:text>selectIdQuery.addFieldToSelect(</xsl:text><xsl:value-of select="dao-interface/name"/>.ALIAS_NAME, 
				<xsl:value-of select="$interface/name"/><xsl:text>Field.ID</xsl:text><xsl:text>);</xsl:text>
		selectIdQuery.addToFrom( <xsl:value-of select="dao-interface/name"/>.TABLE_NAME, <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME );
	</xsl:if>
	
	<!-- count query -->
	countQuery = new SqlQuery();
	<xsl:text>countQuery.addCountToSelect(</xsl:text>
	<xsl:value-of select="$interface/name"/>
	<xsl:text>Field.</xsl:text>
	<xsl:value-of select="class/identifier/attribute/field/@name | class/identifier/association/field/@name"/>
	<xsl:text>,</xsl:text> <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME );
	countQuery.addToFrom( <xsl:value-of select="dao-interface/name"/>.TABLE_NAME, <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME );

	<!--  insert query -->
	insertQuery = new SqlInsert(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME);
	<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute[@transient='false']/field | class/association/field | class/attribute//properties/property/field">
		<xsl:if test="sequence">
			insertQuery.addAutoIncrementField(<xsl:value-of select="$interface/name"/>
			<xsl:text>Field.</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>);</xsl:text>
		</xsl:if>
		<xsl:if test="not(sequence)">
			insertQuery.addBindedField(<xsl:value-of select="$interface/name"/>
			<xsl:text>Field.</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>);</xsl:text>
		</xsl:if>
	</xsl:for-each>

	<!--  update query -->
	updateQuery = new SqlUpdate(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME);
	<xsl:for-each select="class/identifier/attribute/field | class/identifier/association/field | class/attribute[@transient='false']/field | class/association/field | class/attribute//properties/property/field">
		updateQuery.addBindedField(<xsl:value-of select="$interface/name"/>
		<xsl:text>Field.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>);</xsl:text>
	</xsl:for-each>
	
	<!-- delete query -->
	deleteQuery = new SqlDelete(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME);

</xsl:template>

	<!-- Méthodes d'accès aux différentes queries -->
	<xsl:template match="dao" mode="sql-getter">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de sélection des entités (pour qu'elle puisse être modifiée).&#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête de sélection des entités.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public DaoQuery getSelectDaoQuery() {&#13;</xsl:text>
		<xsl:text>		return new DaoQueryImpl(selectQuery.clone(),this.getEntityName());&#13;</xsl:text>
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:if test="count(class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
			<xsl:text>	/**&#13;</xsl:text>
			<xsl:text>	 * Renvoie un clone de la requête de sélection des identifiants (pour qu'elle puisse être modifiée).&#13;</xsl:text>
			<xsl:text>	 * @return un clone de la requête de sélection des identifiants.&#13;</xsl:text>
			<xsl:text>	 */&#13;</xsl:text>
			<xsl:text>	@Override&#13;</xsl:text>
			<xsl:text>	public DaoQuery getSelectIdDaoQuery() {&#13;</xsl:text>
			<xsl:text>		return new DaoQueryImpl(selectIdQuery.clone(),this.getEntityName());&#13;</xsl:text>
			<xsl:text>	}&#13;&#13;</xsl:text>
		</xsl:if>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de comptage (pour qu'elle puisse être modifiée).&#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête de comptage.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public DaoQuery getCountDaoQuery() {&#13;</xsl:text>
		<xsl:text>		return new DaoQueryImpl(countQuery.clone(),this.getEntityName());&#13;</xsl:text>
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête d'insertion (pour qu'elle puisse être modifiée).&#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête d'insertion.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public SqlInsert getInsertQuery() {&#13;</xsl:text>
		<xsl:text>		return insertQuery.clone();&#13;</xsl:text>
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête d'update (pour qu'elle puisse être modifiée).&#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête d'update.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public SqlUpdate getUpdateQuery() {&#13;</xsl:text>
		<xsl:text>		return updateQuery.clone();&#13;</xsl:text>
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de suppression (pour qu'elle puisse être modifiée).&#13;</xsl:text>
		<xsl:text>	 * @return renvoie un clone de la requête de suppression.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public SqlDelete getDeleteQuery() {&#13;</xsl:text>
		<xsl:text>		return deleteQuery.clone();&#13;</xsl:text>
		<xsl:text>	}&#13;&#13;</xsl:text>
	</xsl:template>

<!-- 
<xsl:template name="dao-sql-addwherecondition-to-delete">
	<xsl:param name="interface"/>
	<xsl:param name="object"/>
	<xsl:param name="value"/>
	<xsl:param name="fields"/>
	
	<xsl:text>oSqlDelete.addEqualsConditionToWhere( </xsl:text>
	<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	<xsl:variable name="position" select="position()"/>
	<xsl:value-of select="$fields[position() = $position]/@name"/>
	<xsl:text>, </xsl:text><xsl:value-of select="//dao-interface/name"/>.ALIAS_NAME, 
	
	<xsl:if test="$object">
	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:if test="parent::association">
		<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:text>()</xsl:text>
	</xsl:if>
	
	<xsl:if test="$value">
		<xsl:value-of select="$value"/>
	</xsl:if>
	
	<xsl:text>, SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/>
	<xsl:text>);</xsl:text>
</xsl:template>

<xsl:template name="dao-sql-addwherecondition-to-select">
	<xsl:param name="interface"/>
	<xsl:param name="object"/>
	<xsl:param name="daoquery"/>	
	
	<xsl:value-of select="$daoquery"/>
	<xsl:text>.getSqlQuery().addEqualsConditionToWhere( </xsl:text>
	<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text><xsl:value-of select="field/@name"/>
	<xsl:text>, </xsl:text><xsl:value-of select="//dao-interface/name"/>.ALIAS_NAME, 
	
	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>
	</xsl:if>
	
	<xsl:if test="parent::association">
		<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
	</xsl:if>
	
	<xsl:text>(), SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/>
	<xsl:text>);</xsl:text>
</xsl:template>
 -->

<!--
Add equals condition linked to an object attribute, value is specified 
 -->
<xsl:template name="dao-sql-addequalscondition-withvalue">
	<xsl:param name="interface"/>
	<xsl:param name="queryObject"/>	
	<xsl:param name="object"/>
	<xsl:param name="value"/>
	<xsl:param name="fields"/>
	<xsl:param name="returnObject"/>

	<xsl:if test="$returnObject">
		<xsl:text>SqlEqualsValueCondition </xsl:text>
		<xsl:value-of select="$returnObject"/><xsl:text> = </xsl:text>
	</xsl:if>

	<xsl:value-of select="$queryObject"/><xsl:text>.addEqualsConditionToWhere(</xsl:text>

	<xsl:variable name="position" select="position()"/>
	<xsl:variable name="field" select="$fields[position() = $position]"/>
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/interface/name"/>
		<xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:value-of select="$field/@name"/>
	<xsl:text>, </xsl:text>
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/dao-interface/name"/>
		<xsl:text>.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="/dao/dao-interface/name"/>
		<xsl:text>.</xsl:text>
	</xsl:if>
	<xsl:text>ALIAS_NAME, </xsl:text>
	
	<xsl:if test="$object">
	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:if test="parent::association">
		<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:text>()</xsl:text>
	</xsl:if>
	
	<xsl:if test="$value">
		<xsl:value-of select="$value"/>
	</xsl:if>
	<xsl:text>, SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/>
	<xsl:text>);</xsl:text>
</xsl:template>

<!--
Add equals condition linked to an object attribute, value is specified (no alias) 
 -->
<xsl:template name="dao-delete-addequalscondition-withvalue">
	<xsl:param name="interface"/>
	<xsl:param name="queryObject"/>	
	<xsl:param name="object"/>
	<xsl:param name="value"/>
	<xsl:param name="fields"/>
	<xsl:param name="returnObject"/>

	<xsl:if test="$returnObject">
		<xsl:text>SqlEqualsValueCondition </xsl:text>
		<xsl:value-of select="$returnObject"/><xsl:text> = </xsl:text>
	</xsl:if>

	<xsl:value-of select="$queryObject"/><xsl:text>.addEqualsConditionToWhere(</xsl:text>

	<xsl:variable name="position" select="position()"/>
	<xsl:variable name="field" select="$fields[position() = $position]"/>
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/interface/name"/>
		<xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	</xsl:if>
	<xsl:value-of select="$field/@name"/>
	<xsl:text>, </xsl:text>
<!-- 
	<xsl:if test="$field/ancestor::association[@type='many-to-many']">
		<xsl:value-of select="$field/ancestor::association/join-table/dao-interface/name"/>
		<xsl:text>.</xsl:text>
	</xsl:if>
	<xsl:if test="not($field/ancestor::association[@type='many-to-many'])">
		<xsl:value-of select="//dao-interface/name"/>
		<xsl:text>.</xsl:text>
	</xsl:if>
	<xsl:text>ALIAS_NAME, </xsl:text>
 -->
	<xsl:if test="$object">
	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:if test="parent::association">
		<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:text>()</xsl:text>
	</xsl:if>
	
	<xsl:if test="$value">
		<xsl:value-of select="$value"/>
	</xsl:if>
	<xsl:text>, SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/>
	<xsl:text>);</xsl:text>
</xsl:template>

<!--
Add equals condition linked to an object attribute, value is not yet specified 
 -->
<xsl:template name="dao-sql-addequalscondition-withoutvalue">
	<xsl:param name="interface"/>
	<xsl:param name="queryObject"/>	
	<xsl:param name="fields"/>
	<xsl:param name="returnObject"/>

	<xsl:if test="$returnObject">	
		<xsl:text>SqlEqualsValueCondition </xsl:text>
		<xsl:value-of select="$returnObject"/><xsl:text> = </xsl:text>
	</xsl:if>
	<xsl:value-of select="$queryObject"/><xsl:text>.addEqualsConditionToWhere(</xsl:text>
	<xsl:value-of select="$interface/name"/><xsl:text>Field.</xsl:text>
	<xsl:variable name="position" select="position()"/>
	<xsl:value-of select="$fields[position() = $position]/@name"/>
<!-- 	<xsl:text>, </xsl:text><xsl:value-of select="//dao-interface/name"/>.ALIAS_NAME, SqlType.<xsl:value-of select="field/@jdbc-type"/> -->
	<xsl:text>, SqlType.</xsl:text><xsl:value-of select="field/@jdbc-type"/>
	<xsl:text>);</xsl:text>
</xsl:template>

<!-- Change equals condition value linked to an object attribute  -->
<xsl:template name="dao-sql-setequalsconditionvalue">
	<xsl:param name="interface"/>
	<xsl:param name="object"/>
	<xsl:param name="fields"/>
	<xsl:param name="conditionObject"/>
	
	<xsl:value-of select="$conditionObject"/>
	<xsl:text>.setValue(</xsl:text>
	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:if test="parent::association">
		<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/><xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
	</xsl:if>
	<xsl:text>());</xsl:text>
</xsl:template>

<!-- Ajoute les jointures des join-classes -->
<xsl:template name="dao-sql-joinclass-addinnerjoin">
	<xsl:param name="classe"/>
	<xsl:param name="interface"/>

	<xsl:variable name="pkFields" select="$classe/identifier/attribute/field | $classe/identifier/association/field"/>
	<xsl:for-each select="join-tables/join-table">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="field" select="$pkFields[position() = $position]"/>
		p_oDaoQuery.getSqlQuery().getFirstFromPart().addSqlJoin(
			new SqlTableInnerJoin(<xsl:value-of select="dao-interface/name"/>
			<xsl:text>.TABLE_NAME, </xsl:text> 
			<xsl:value-of select="dao-interface/name"/>
			<xsl:text>.ALIAS_NAME,</xsl:text>
			<xsl:value-of select="/dao/dao-interface/name"/>
			<xsl:text>.TABLE_NAME,</xsl:text>
			<xsl:for-each select="key-fields/field">
				new SqlEqualsFieldCondition(
					<xsl:value-of select="../../interface/name"/>
					<xsl:text>Field.</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="../../dao-interface/name"/>
					<xsl:text>.ALIAS_NAME,</xsl:text>
					<xsl:value-of select="$interface/name"/>
					<xsl:text>Field.</xsl:text>
					<xsl:value-of select="$field/@name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="/dao/dao-interface/name"/>.ALIAS_NAME )
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		<xsl:text>));</xsl:text>
	</xsl:for-each>
</xsl:template>


	<!-- Ajoute les equals condition correspondant aux paramètres de la méthode -->
	<xsl:template name="dao-sql-addequalscondition-of-parameters">
		<xsl:param name="interface"/>
		<xsl:param name="queryObject"/>

		<xsl:variable name="methodName" select="@name"/>
		<xsl:variable name="methodByRef" select="../method-signature[@name=$methodName and @by-value='false']"/>
		<xsl:variable name="paramFields" select="$methodByRef/method-parameter/attribute/field | $methodByRef/method-parameter/association/field | $methodByRef/method-parameter/association/join-table/crit-fields/field"/>

		<xsl:for-each select="descendant::attribute">
				<xsl:variable name="method-param" select="ancestor::method-parameter"/>
				<xsl:call-template name="dao-sql-addequalscondition-withvalue">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="queryObject" select="$queryObject"/>
					<xsl:with-param name="value">
						<xsl:if test="$method-param/@by-value = 'true'">
							<xsl:value-of select="$method-param/@name"/>
						</xsl:if>
						<xsl:if test="$method-param/@by-value = 'false'">
							<xsl:value-of select="$method-param/@name"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="get-accessor"/>
							<xsl:text>()</xsl:text>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="fields" select="$paramFields"/>
				</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- Ajoute les equals condition correspondant aux paramètres de la méthode -->
	<xsl:template name="dao-delete-addequalscondition-of-parameters">
		<xsl:param name="interface"/>
		<xsl:param name="queryObject"/>

		<xsl:variable name="methodName" select="@name"/>
		<xsl:variable name="methodByRef" select="../method-signature[@name=$methodName and @by-value='false']"/>
		<xsl:variable name="paramFields" select="$methodByRef/method-parameter/attribute/field | $methodByRef/method-parameter/association/field | $methodByRef/method-parameter/association/join-table/crit-fields/field"/>

		<xsl:for-each select="descendant::attribute">
				<xsl:variable name="method-param" select="ancestor::method-parameter"/>
				<xsl:call-template name="dao-delete-addequalscondition-withvalue">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="queryObject" select="$queryObject"/>
					<xsl:with-param name="value">
						<xsl:if test="$method-param/@by-value = 'true'">
							<xsl:value-of select="$method-param/@name"/>
						</xsl:if>
						<xsl:if test="$method-param/@by-value = 'false'">
							<xsl:value-of select="$method-param/@name"/>
							<xsl:text>.</xsl:text>
							<xsl:value-of select="get-accessor"/>
							<xsl:text>()</xsl:text>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="fields" select="$paramFields"/>
				</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
