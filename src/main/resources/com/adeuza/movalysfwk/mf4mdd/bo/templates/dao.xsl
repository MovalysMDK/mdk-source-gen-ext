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

<xsl:include href="includes/dao-historisation.xsl"/>
<xsl:include href="includes/string.xsl"/>
<xsl:include href="includes/jdbc.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-delete.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-insert.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-parameter.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-update.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-relation-to-one.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-fillretrieve-relation-to-one.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-pk-firstpass.xsl"/>
<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-pk-secondpass.xsl"/>
<xsl:include href="includes/dao-delete-update-generic.xsl"/>
<xsl:include href="includes/dao-reference.xsl"/>
<xsl:include href="includes/dao-cascadedelete.xsl"/>
<xsl:include href="includes/dao-cascadegetlist.xsl"/>
<xsl:include href="includes/dao-cascadegetlist-post.xsl"/>
<xsl:include href="includes/dao-cascadesaveupdate.xsl"/>
<xsl:include href="includes/dao-deleteby.xsl"/>
<xsl:include href="includes/dao-deletebypk.xsl"/>
<xsl:include href="includes/dao-deletelist.xsl"/>
<xsl:include href="includes/dao-getbypk.xsl"/>
<xsl:include href="includes/dao-getlist.xsl"/>
<xsl:include href="includes/dao-getlist-id.xsl"/>
<xsl:include href="includes/dao-getnb.xsl"/>
<xsl:include href="includes/dao-getnbby.xsl"/>
<xsl:include href="includes/dao-getby-id-or-reference.xsl"/>
<xsl:include href="includes/dao-joinclass.xsl"/>
<xsl:include href="includes/dao-save-or-update.xsl"/>
<xsl:include href="includes/dao-save-or-update-list.xsl"/>
<xsl:include href="includes/dao-exist.xsl"/>
<xsl:include href="includes/dao-save.xsl"/>
<xsl:include href="includes/dao-savelist.xsl"/>
<xsl:include href="includes/dao-update.xsl"/>
<xsl:include href="includes/dao-updatelist.xsl"/>
<xsl:include href="includes/dao-getby.xsl"/>
<xsl:include href="includes/dao-getlistby.xsl"/>
<xsl:include href="includes/dao-valueobject.xsl"/>
<xsl:include href="includes/dao-fill.xsl"/>
<xsl:include href="includes/dao-sql.xsl"/>


<xsl:output method="text"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="dao">

<xsl:variable name="interface" select="interface"/>
<xsl:variable name="class" select="class"/>
	
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.BeanAutowired;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.BeanService;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.PackagePrivate;
<xsl:if test="class/@join-class = 'true'">
import org.apache.commons.collections.CollectionUtils;
</xsl:if>

import java.io.IOException;
import java.sql.Connection ;
import java.sql.Date ;
import java.sql.PreparedStatement ;
import java.sql.ResultSet ;
import java.sql.SQLException ;
import java.util.Collection;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.TreeSet;
import java.util.Map.Entry;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.AbstractBOPersistableEntity;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOListImpl;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOList;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.references.Reference;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.references.ListReferences;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.references.ReferenceState;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.enumeration.HistorisationEntityLevelType;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.enumeration.HistorisationBlocType;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.helper.HelperHistorisationBlocLevel;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.helper.HelperHistorisationBlocType;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.map.EntityHistorisationBlocMap;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.map.QueryHistorisationBlocMap;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.historisation.map.QueryHistorisationBlocMapImpl;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.historisation.service.HistorisationService;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.service.context.ContextImpl;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.service.context.ItfTransactionalContext ;

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.AbstractEntityDao ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoSession ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.CascadeOptim ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.CascadeOptimDefinition;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoException ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoQuery ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoQueryImpl ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.Field;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.PairValue;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.StatementBinderCallBack;
/*DISABLED IN BACKPORT
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.dynamical.DynamicalFieldDao ;
*/
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.references.ReferenceDao;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.SqlType;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.conditions.SqlInValueCondition;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.conditions.SqlNotInValueCondition;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.conditions.SqlEqualsValueCondition;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.conditions.SqlEqualsFieldCondition;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.joins.SqlTableInnerJoin;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlQuery;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlInsert;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlUpdate;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlDelete;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.StatementBinder;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.ResultSetReader;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.references.ReferenceValue;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.references.ReferenceValueImpl;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.references.ReferenceRowReaderCallBack ;

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Classe de DAO : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@SuppressWarnings("unchecked")
public abstract class <xsl:value-of select="name"/> extends AbstractEntityDao<xsl:text>&lt;</xsl:text><xsl:value-of select="interface/name"/><xsl:text>&gt; implements InitializingBean {

	/** 
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(</xsl:text><xsl:value-of select="name"/>.class);

	<xsl:if test="class/identifier/attribute/field/sequence">
	/**
	 * Liste des colonnes dont la valeur est générée par la base de données (séquence)
	 */
	protected static final String[] GENERATED_COLUMNS = {<xsl:for-each select="class/identifier/attribute/field/sequence">
			<xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="../@cascade-name"/><xsl:value-of select="../@name"/>.name()<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text></xsl:if></xsl:for-each><xsl:text>};</xsl:text></xsl:if>

	<xsl:call-template name="dao-sql-queries"/>

	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
	/**
	 * Map des méthodes de référencement
	 */
	private Map<xsl:text>&lt;</xsl:text>LoadMethod&lt;<xsl:value-of select="interface/name"/>&gt;,ReferenceValue<xsl:text>&gt;</xsl:text> referenceMap = new HashMap<xsl:text>&lt;</xsl:text>LoadMethod&lt;<xsl:value-of select="interface/name"/>&gt;,ReferenceValue<xsl:text>&gt;</xsl:text>();
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected Map&lt;LoadMethod&lt;<xsl:value-of select="interface/name"/>&gt;,ReferenceValue&gt; getReferenceMap(){
		return this.referenceMap;
	}
	</xsl:if>

	<xsl:if test="count(class/identifier/descendant::attribute) = 1">
	/**
	 * Dao de l'entité DynamicalField
	 */
	/*DISABLED IN BACKPORT
	@BeanAutowired
	private DynamicalFieldDao dynamicalFieldDao ;
	*/
	</xsl:if>
	
	/**
	 * Dao de l'entité Reference
	 */
	@BeanAutowired
	private ReferenceDao referenceDao ;

	<xsl:for-each select="dao-bean-ref">
	/**
	 * Dao <xsl:value-of select="@type-short-name"/>
	 */
	@BeanAutowired
	protected <xsl:value-of select="@type-short-name"/>
	<xsl:text> </xsl:text><xsl:value-of select="@name"/> ;
	</xsl:for-each>

	/**
	 * Factory <xsl:value-of select="class/pojo-factory-interface/name"/>
	 */	
	@BeanAutowired
	protected <xsl:value-of select="class/pojo-factory-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="class/pojo-factory-interface/bean-name"/> ;
	
	<xsl:for-each select="dao-bean-ref">
	/**
	 * Factory <xsl:value-of select="./pojo-factory-interface/name"/>
	 */
	@BeanAutowired
	protected <xsl:value-of select="./pojo-factory-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./pojo-factory-interface/bean-name"/> ;
	</xsl:for-each>
	
	
	<xsl:call-template name="cascade-init-optimDefinition">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>
	</xsl:call-template>
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public String getTableName() {
		return <xsl:value-of select="dao-interface/name"/>.TABLE_NAME ;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected String getAliasName() {
		return <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME ;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected String getEntityName() {
		return <xsl:value-of select="interface/name"/>.ENTITY_NAME ;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected PairValue&lt;Field, SqlType&gt;[] getPKFields() {
		return <xsl:value-of select="dao-interface/name"/>.PK_FIELDS ;
	}
	
	<xsl:call-template name="dao-sql-getter"/>
	
	<xsl:call-template name="dao-getbypk"/>
	<xsl:call-template name="dao-getlist"/>
	<xsl:call-template name="dao-getlist-id"/>
		
	<xsl:call-template name="dao-save-or-update"/>
	<xsl:call-template name="dao-save-or-update-list"/>
	
	<xsl:call-template name="dao-deletebypk">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>
	</xsl:call-template>
	
	<xsl:call-template name="dao-deletelist">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>	
	</xsl:call-template>
	
	<xsl:call-template name="dao-getnb"/>
	
	<xsl:apply-templates select="method-signature"/>
	
	<xsl:if test="class[@join-class = 'true']">
		<xsl:call-template name="dao-joinclass">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="class" select="class"/>
		</xsl:call-template>
		
		<xsl:call-template name="dao-joinclass-insertfromside">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="joinclass" select="class"/>
			<xsl:with-param name="class1" select="left-class"/>
			<xsl:with-param name="class2" select="right-class"/>
			<xsl:with-param name="asso1" select="class/right-association"/>
			<xsl:with-param name="asso2" select="class/left-association"/>
			<xsl:with-param name="masterclass" select="left-class"/>
		</xsl:call-template>
		
		<xsl:call-template name="dao-joinclass-insertfromside">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="joinclass" select="class"/>
			<xsl:with-param name="class1" select="right-class"/>
			<xsl:with-param name="class2" select="left-class"/>
			<xsl:with-param name="asso1" select="class/left-association"/>
			<xsl:with-param name="asso2" select="class/right-association"/>			
			<xsl:with-param name="masterclass" select="left-class"/>
		</xsl:call-template>	
	</xsl:if>

	<xsl:call-template name="dao-save">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>
	</xsl:call-template>
	
	<xsl:call-template name="dao-savelist">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>	
	</xsl:call-template>
	
	<xsl:call-template name="dao-update"/>
	<xsl:call-template name="dao-updatelist"/>

	<xsl:call-template name="dao-exist"/>
	
	<xsl:call-template name="dao-getby-id-or-reference"/>
	
	<xsl:call-template name="dao-fill">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>	
	</xsl:call-template>
	
	<xsl:call-template name="dao-valueobject"/>
	
	<xsl:call-template name="dao-valueobject-optimlist"/>
		
	/**
	 * Bind un prepareStatement d'insertion
	 *
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/> à insérer
	 * @param p_oPreparedStatement requête SQL précompilée
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 * @throws SQLException déclenchée si une erreur SQL survient
	 */
	protected void bindInsert( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, PreparedStatement p_oPreparedStatement</xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException, SQLException {
		<xsl:for-each select="interface/linked-interface"><xsl:if test="name='MAdmAble'">
		this.prepareToWrite(p_o<xsl:value-of select="//dao/interface/name"/>,p_oContext);
		</xsl:if></xsl:for-each>
		StatementBinder oStatementBinder = new StatementBinder(p_oPreparedStatement);
		<xsl:for-each select="class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
			<xsl:call-template name="jdbc-bind-insert">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="statement">oStatementBinder</xsl:with-param>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
				<xsl:with-param name="countSeq"><xsl:value-of select="count(preceding::sequence[not(../../parent::association) and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')])"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	}
	
	/**
	 * Bind un preparedStatement de mise à jour
	 *
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/> à mettre à jour
	 * @param p_oPreparedStatement requête SQL précompilée
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 * @throws SQLException déclenchée si une erreur SQL survient
	 */
	protected void bindUpdate( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, PreparedStatement p_oPreparedStatement</xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException, SQLException {
		<xsl:for-each select="interface/linked-interface">
			<xsl:if test="name='MAdmAble'">
				this.prepareToWrite(p_o<xsl:value-of select="//dao/interface/name"/>, p_oContext);
			</xsl:if>
		</xsl:for-each>
		StatementBinder oStatementBinder = new StatementBinder(p_oPreparedStatement);
		<xsl:for-each select="class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
			<xsl:call-template name="jdbc-bind-update">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="statement">oStatementBinder</xsl:with-param>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:variable name="countAttr" select="count(class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')])"/>
		
		<xsl:for-each select="class/identifier/descendant::attribute[(not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
			<xsl:call-template name="jdbc-bind-update">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="statement">oStatementBinder</xsl:with-param>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
				<xsl:with-param name="posOffset"><xsl:value-of select="$countAttr"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	}
	
	<!-- 
	<xsl:call-template name="cascade-getlist-pre">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>		
	</xsl:call-template>
	 -->
	 
 	<xsl:call-template name="cascade-createCascadeOptim">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>		
	</xsl:call-template>
	
	<xsl:call-template name="cascade-getlist-post">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>	
	</xsl:call-template>

	<xsl:call-template name="cascade-fill-pre">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>	
	</xsl:call-template>
	
	<xsl:call-template name="cascade-fill-post">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>	
	</xsl:call-template>
	
	/**
	 * {@inheritDoc}
	 * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
	 */
	@Override
	public void afterPropertiesSet() throws Exception {
	
		<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
		referenceMap.put(LoadMethod<xsl:value-of select="interface/name"/>.BY_ID,new ReferenceValueImpl(
			"getListByIds", "fillByIds", new String[] { 
				<xsl:value-of select="dao-interface/name"/><xsl:text>.ALIAS_NAME + '_' + </xsl:text><xsl:value-of select="dao-interface/name"/>.<xsl:value-of select="$interface/name"/><xsl:text>Field.ID.getColumnIndex()</xsl:text>
		}));
		<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MCodableEntity']) > 0">
		referenceMap.put(LoadMethod<xsl:value-of select="interface/name"/>.BY_CODE,new ReferenceValueImpl(
			 "getListByCodes", "fillByCodes", new String[] { 
				<xsl:value-of select="dao-interface/name"/><xsl:text>.ALIAS_NAME + '_' + </xsl:text><xsl:value-of select="dao-interface/name"/>.<xsl:value-of select="$interface/name"/><xsl:text>Field.CODE.getColumnIndex()</xsl:text>
		}));</xsl:if>
		<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableBOEntity']) > 0 and count($class/implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']) > 0">
		referenceMap.put(LoadMethod<xsl:value-of select="interface/name"/>.BY_REFERENCE,new ReferenceValueImpl(
			"getListByReferences", "fillByReferences", new String[] { 
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.ID.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.LICENCE.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.IDMOVALYS.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.IDSIEXT.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.LASTMODIFDATE.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.STATE.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.FLAG.getColumnIndex(),
				ReferenceDao.ALIAS_NAME + '_' + ReferenceDao.ReferenceField.NUMVERSION.getColumnIndex()
		}));</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="dao-sql-queries-initialize"/>
		
		<xsl:call-template name="cascade-init-optimDefinition-initialize">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="classe" select="class"/>
		</xsl:call-template>
	}
}

</xsl:template>

</xsl:stylesheet>
