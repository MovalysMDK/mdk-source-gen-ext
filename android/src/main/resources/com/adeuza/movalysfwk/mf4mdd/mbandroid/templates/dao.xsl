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

	<xsl:include href="includes/imports.xsl"/>

<!--<xsl:include href="includes/dao-historisation.xsl"/>-->
	<xsl:include href="includes/string.xsl"/>
	<xsl:include href="includes/jdbc.xsl"/>
<!--<xsl:include href="includes/jdbc-bind/jdbc-bind-delete.xsl"/>-->
	<xsl:include href="includes/jdbc-bind/jdbc-bind-insert.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-parameter.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-update.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-relation-to-one.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-fillretrieve-relation-to-one.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-pk-firstpass.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-retrieve-pk-secondpass.xsl"/>
	<xsl:include href="includes/dao-delete-update-generic.xsl"/>
<!--<xsl:include href="includes/dao-reference.xsl"/>-->
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
<!--<xsl:include href="includes/dao-getby-id-or-reference.xsl"/>-->
	<xsl:include href="includes/dao-joinclass.xsl"/>

	<xsl:include href="includes/dao-save-or-update.xsl"/>
	<xsl:include href="includes/dao-save-or-update-list.xsl"/>
	<xsl:include href="includes/dao-exist.xsl"/>
	<xsl:include href="includes/dao-existby.xsl"/>
	<xsl:include href="includes/dao-save.xsl"/>
	<xsl:include href="includes/dao-savelist.xsl"/>
	<xsl:include href="includes/dao-update.xsl"/>
	<xsl:include href="includes/dao-updatelist.xsl"/>
	<xsl:include href="includes/dao-getby.xsl"/>
	<xsl:include href="includes/dao-getlistby.xsl"/>
	<xsl:include href="includes/dao-valueobject.xsl"/>
<!--<xsl:include href="includes/dao-fill.xsl"/>-->
	<xsl:include href="includes/dao-sql.xsl"/>

<xsl:output method="text"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="dao">
	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="class" select="class"/>

	<xsl:text>package </xsl:text><xsl:value-of select="package"/><xsl:text>;&#13;&#13;</xsl:text>

	<xsl:apply-templates select="." mode="declare-imports"/>

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Classe de DAO : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 */
public abstract class <xsl:value-of select="name"/><xsl:text> extends AbstractEntityDao&lt;</xsl:text>
	<xsl:value-of select="interface/name"/><xsl:text>&gt; implements Initializable {&#13;</xsl:text>

	<xsl:if test="class/identifier/attribute/field/sequence">
	/**
	 * Liste des colonnes dont la valeur est générée par la base de données (séquence)
	 */
	protected static final String[] GENERATED_COLUMNS = {<xsl:for-each select="class/identifier/attribute/field/sequence">
			<xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="../@cascade-name"/><xsl:value-of select="../@name"/>.name()<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text></xsl:if></xsl:for-each><xsl:text>};</xsl:text></xsl:if>

	<xsl:apply-templates select="." mode="sql-queries"/>

	/**
	 * Factory <xsl:value-of select="class/pojo-factory-interface/name"/>
	 */	
	protected <xsl:value-of select="class/pojo-factory-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="class/pojo-factory-interface/bean-name"/> ;

	<xsl:apply-templates select="dao-bean-ref" mode="dao"/>
	<xsl:apply-templates select="dao-bean-ref" mode="factory"/>

	<xsl:call-template name="cascade-init-optimDefinition">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>
	</xsl:call-template>

	<xsl:if test="class[customizable='true']">
		protected CustomFieldDao&lt;<xsl:value-of select="class/implements/interface/@name"/>&gt; customFieldDao;
	</xsl:if>

	<xsl:apply-templates select="." mode="initialize"/>

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
	protected FieldType[] getPKFields() {
		return <xsl:value-of select="dao-interface/name"/>.PK_FIELDS ;
	}

	<xsl:apply-templates select="." mode="sql-getter"/>

	<xsl:apply-templates select="." mode="get-by-pk"/>
	<xsl:apply-templates select="." mode="get-list"/>
	<xsl:apply-templates select="." mode="get-list-id"/>

	<xsl:apply-templates select="." mode="save-or-update"/>
	<xsl:apply-templates select="." mode="save-or-update-list"/>

	<xsl:apply-templates select="." mode="delete-by-pk"/>
	<xsl:apply-templates select="." mode="delete-list"/>

	<xsl:apply-templates select="." mode="get-nb"/>
	
	<xsl:apply-templates select="." mode="delete-cascade-getter"/>

	<xsl:apply-templates select="method-signature"/>

	<xsl:if test="class[@join-class = 'true']">
		<xsl:apply-templates select="." mode="join-class"/>

		<xsl:apply-templates select="." mode="join-class-insert-from-side">
			<xsl:with-param name="class1" select="left-class"/>
			<xsl:with-param name="class2" select="right-class"/>
			<xsl:with-param name="asso1" select="class/right-association"/>
			<xsl:with-param name="asso2" select="class/left-association"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="join-class-insert-from-side">
			<xsl:with-param name="class1" select="right-class"/>
			<xsl:with-param name="class2" select="left-class"/>
			<xsl:with-param name="asso1" select="class/left-association"/>
			<xsl:with-param name="asso2" select="class/right-association"/>
		</xsl:apply-templates>
	</xsl:if>

	<xsl:apply-templates select="." mode="save"/>
	<xsl:apply-templates select="." mode="savelist"/>
	<xsl:apply-templates select="." mode="update"/>
	<xsl:apply-templates select="." mode="updatelist"/>

	<xsl:apply-templates select="." mode="exist"/>

	<!--<xsl:call-template name="dao-getby-id-or-reference"/>-->
	
	<!-- <xsl:call-template name="dao-fill">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="class" select="class"/>	
	</xsl:call-template> -->
	
	<xsl:apply-templates select="." mode="value-object"/>
	<xsl:apply-templates select="." mode="value-object-optim-list"/>

	/**
	 * Bind un prepareStatement d'insertion
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/> à insérer
	 * @param p_oStatement requête SQL précompilée
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Override
	protected void bindInsert( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, MDKSQLiteStatement p_oStatement</xsl:text>, MContext p_oContext ) throws DaoException {
		<xsl:for-each select="class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
			<xsl:call-template name="jdbc-bind-insert">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="statement">p_oStatement</xsl:with-param>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
				<xsl:with-param name="countSeq"><xsl:value-of select="count(preceding::sequence[not(../../parent::association) and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')])"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	}

	/**
	 * Bind un preparedStatement de mise à jour
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/> à mettre à jour
	 * @param p_oStatement requête SQL précompilée
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Override
	protected void bindUpdate( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, MDKSQLiteStatement p_oStatement</xsl:text>, MContext p_oContext ) throws DaoException {
		<xsl:for-each select="class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
			<xsl:call-template name="jdbc-bind-update">
				<xsl:with-param name="interface" select="$interface"/>
				<xsl:with-param name="statement">p_oStatement</xsl:with-param>
				<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:variable name="countAttr" select="count(class/descendant::attribute[@transient='false' and (not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')])"/>
		
		<!-- if entity doesnot hold old id, bind where with current id -->
		<xsl:if test="class/parameters/parameter[@name='oldidholder'] = 'false'">
			<xsl:for-each select="class/identifier/descendant::attribute[(not(../@type) or ../@type!='one-to-many') and (not(../../@type) or ../../@type!='one-to-many')]">
				<xsl:call-template name="jdbc-bind-update">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="statement">p_oStatement</xsl:with-param>
					<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
					<xsl:with-param name="posOffset"><xsl:value-of select="$countAttr"/></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<!-- if entity holds old id, bind where with old id -->
		<xsl:if test="class/parameters/parameter[@name='oldidholder'] = 'true'">
			<xsl:for-each select="class/attribute[parameters/parameter[@name= 'oldidholder'] = 'true']">
				<xsl:call-template name="jdbc-bind-update">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="statement">p_oStatement</xsl:with-param>
					<xsl:with-param name="object">p_o<xsl:value-of select="$interface/name"/></xsl:with-param>
					<xsl:with-param name="posOffset"><xsl:value-of select="$countAttr"/></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	}

	<xsl:apply-templates select="." mode="create-cascade-optim"/>
	<xsl:apply-templates select="." mode="create-cascade-get-list-post"/>
<!-- 
	<xsl:call-template name="cascade-fill-pre">
		<xsl:with-param name="interface" select="interface"/>
		<xsl:with-param name="classe" select="class"/>	
	</xsl:call-template>
-->	
	<xsl:apply-templates select="." mode="cascade-fill-post"/>
}

	</xsl:template>

	<xsl:template match="import">
		<!-- pour eviter les doublons d'import de java.util.List car il est mis en dur dans le xsl -->
		<xsl:if test=". != 'java.util.List'">
			<xsl:text>import </xsl:text>
			<xsl:value-of select="."/>
			<xsl:text> ;&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dao-bean-ref" mode="dao">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Dao </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	protected </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="dao-bean-ref" mode="factory">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Factory </xsl:text><xsl:value-of select="pojo-factory-interface/name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	protected </xsl:text><xsl:value-of select="pojo-factory-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./pojo-factory-interface/bean-name"/><xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="dao" mode="initialize">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Initializes the private attributes of this DAO: factories and daos use by this dao.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	public void initialize() {&#13;</xsl:text>
		<xsl:text>		this.</xsl:text>
		<xsl:value-of select="class/pojo-factory-interface/bean-name"/>
		<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="class/pojo-factory-interface/name"/>
		<xsl:text>.class);&#13;&#13;</xsl:text>

		<xsl:apply-templates select="dao-bean-ref" mode="initialize"/>

		<xsl:if test="class[customizable='true']">
			this.customFieldDao = BeanLoader.getInstance().getBean(CustomFieldDao.class);
			this.customFieldDao.initialize(<xsl:value-of select="dao-interface/name"/>.class);
		</xsl:if>

		<xsl:apply-templates select="." mode="sql-queries-initialize"/>
		
		<xsl:call-template name="cascade-init-optimDefinition-initialize">
			<xsl:with-param name="interface" select="interface"/>
			<xsl:with-param name="classe" select="class"/>
		</xsl:call-template>
		
		<xsl:text>	}&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Initializes the private attributes of this DAO: factories and daos use by this dao.&#13;</xsl:text>
		<xsl:text>	 * @param p_oContext the context to use&#13;</xsl:text>
		<xsl:text>	 * @throws DaoException if any&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public void initialize(MContext p_oContext) throws DaoException {&#13;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(class/identifier/attribute) = 1 and (class/identifier/attribute[@type-name='long'] or class/identifier/attribute[@type-short-name='Long'])">
				SqlQuery oSelect = new SqlQuery();
				oSelect.addFunctionToSelect(new SqlFunctionSelectPart(SqlFunction.MIN, <xsl:value-of select="interface/name"/>
				<xsl:text>Field.</xsl:text><xsl:value-of select="class/identifier/attribute/field/@name"/>
				<xsl:text>, </xsl:text><xsl:value-of select="dao-interface/name"/>.ALIAS_NAME));
				oSelect.addToFrom(<xsl:value-of select="dao-interface/name"/>.TABLE_NAME, <xsl:value-of select="dao-interface/name"/>.ALIAS_NAME);
				this.lastNewId = (Long) this.genericSelect(new DaoQueryImpl(oSelect, this.getEntityName()), p_oContext, new ResultSetReaderCallBack() {
					@Override
					public Object doRead(AndroidSQLiteResultSet p_oResultSet) throws DaoException {
						long r_lMinId = UNSAVED_VALUE;
						if (p_oResultSet.next()) {
							r_lMinId = p_oResultSet.getLong(1);
							if (r_lMinId >= 0L) {
								r_lMinId = UNSAVED_VALUE;
							}
						}
						return r_lMinId;
					}
				});
			</xsl:when>
			<xsl:otherwise>
				// Nothing to do
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>	}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="dao-bean-ref" mode="initialize">
		<xsl:variable name="ref" select="@name"/>
		<xsl:variable name="interface-name">
			<xsl:choose>
				<xsl:when test="../class/association[dao-interface/bean-ref=$ref]">
					<xsl:value-of select="../class/association[dao-interface/bean-ref=$ref]/interface/name"/>
				</xsl:when>

				<xsl:when test="../class/association/join-table[dao-interface/bean-ref=$ref]">
					<xsl:value-of select="../class/association/join-table[dao-interface/bean-ref=$ref]/interface/name"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="substring-before(@type-short-name, 'Dao')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:text>		this.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text>.class);&#13;</xsl:text>

		<xsl:text>		this.</xsl:text>
		<xsl:value-of select="pojo-factory-interface/bean-name"/>
		<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="pojo-factory-interface/name"/>
		<xsl:text>.class);&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="dao" mode="declare-extra-imports">
		<import>java.io.IOException</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.jdbc.AndroidSQLiteConnection</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.jdbc.AndroidSQLiteResultSet</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.jdbc.AndroidSQLitePreparedStatement</import>
		<import>com.adeuza.movalysfwk.mobile.mf4android.database.sqlite.MDKSQLiteStatement</import>
		<import>java.util.Collection</import>
		<import>java.util.List</import>
		<import>java.util.ArrayList</import>
		<xsl:if test="class[@join-class = 'true']"><import>java.util.Iterator</import></xsl:if>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.Initializable</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContextImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.CascadeSet</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.AbstractEntityDao</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoSession</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.CascadeOptim</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.CascadeOptimDefinition</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoException</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoQuery</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoQueryImpl</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.Field</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.FieldType</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.ResultSetReaderCallBack</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.SqlType</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.ResultSetReader</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlFunction</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlDelete</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlInsert</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlQuery</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlUpdate</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.StatementBinder</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.conditions.SqlInValueCondition</import>
		<xsl:if test="class/descendant::association[@type='one-to-many' and not(parent::association)]"><import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.conditions.SqlNotInValueCondition</import></xsl:if>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.conditions.SqlEqualsValueCondition</import>
		<xsl:if test="method-signature[@type='getListEntite' or @type='getEntite' or @type='deleteEntite']/join-tables/join-table"><import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.conditions.SqlEqualsFieldCondition</import></xsl:if>
		<xsl:if test="method-signature[@type='getListEntite' or @type='getEntite' or @type='deleteEntite']/join-tables/join-table"><import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.joins.SqlTableInnerJoin</import></xsl:if>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.select.SqlFunctionSelectPart</import>
		<xsl:if test="class[customizable='true']">
			<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.customizable.CustomField</import>
			<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.customizable.CustomFieldDao</import>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
