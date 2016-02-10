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
	<xsl:include href="includes/interface.xsl"/>

	<xsl:include href="includes/string.xsl"/>
	<xsl:include href="includes/jdbc.xsl"/>
	<xsl:include href="includes/jdbc-bind/jdbc-bind-insert.xsl"/>
	<xsl:include href="includes/dao-delete-update-generic.xsl"/>
	<xsl:include href="includes/dao-cascadedelete.xsl"/>
	<xsl:include href="includes/dao-deletebypk.xsl"/>
	<xsl:include href="includes/dao-deletelist.xsl"/>
	<xsl:include href="includes/dao-getbypk.xsl"/>
	<xsl:include href="includes/dao-getlist.xsl"/>
	<xsl:include href="includes/dao-getlist-id.xsl"/>
	<xsl:include href="includes/dao-getnb.xsl"/>
	<xsl:include href="includes/dao-existby.xsl"/>
	<xsl:include href="includes/dao-joinclass.xsl"/>
	<xsl:include href="includes/dao-save-or-update.xsl"/>
	<xsl:include href="includes/dao-save-or-update-list.xsl"/>
	<xsl:include href="includes/dao-save-interface.xsl"/>
	<xsl:include href="includes/dao-savelist-interface.xsl"/>
	<xsl:include href="includes/dao-update-interface.xsl"/>
	<xsl:include href="includes/dao-updatelist-interface.xsl"/>
	<xsl:include href="includes/dao-deleteby-interface.xsl"/>
	<xsl:include href="includes/dao-getby-interface.xsl"/>
	<xsl:include href="includes/dao-getlistby-interface.xsl"/>
	<xsl:include href="includes/dao-getnbby-interface.xsl"/>
	<xsl:include href="includes/dao-sql.xsl"/>

	<xsl:output method="text"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="dao-interface">
		<xsl:apply-templates select="." mode="declare-interface"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="dao-interface" mode="declare-extra-imports">
		<import>java.util.Collection</import>
		<import>java.util.List</import>

		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.Scope</import>
		<import>com.adeuza.movalysfwk.mf4jcommons.core.beans.ScopePolicy</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.CascadeSet</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoException</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoQuery</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoSession</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.Field</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.EntityDao</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.PairValue</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.SqlType</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlInsert</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlUpdate</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.query.SqlDelete</import>
	</xsl:template>

	<!-- DOCUMENTATION .............................................................................................. -->

	<xsl:template match="dao-interface" mode="documentation">
		/**
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Interface de DAO : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 */
	</xsl:template>

	<!-- ANNOTATIONS ................................................................................................ -->

	<xsl:template match="dao-interface" mode="class-annotations">
		<xsl:text>@Scope(ScopePolicy.SINGLETON)&#13;</xsl:text>
	</xsl:template>

	<!-- SUPERINTERFACES ............................................................................................ -->

	<xsl:template match="dao-interface" mode="superinterfaces">
		<xsl:text>EntityDao&lt;</xsl:text>
		<xsl:value-of select="dao/interface/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<!-- CONSTANTS .................................................................................................. -->

	<xsl:template match="dao-interface" mode="constants">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Table du Dao&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public static final String TABLE_NAME = "</xsl:text>
		<xsl:value-of select="dao/class/table-name"/>
		<xsl:text>";&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Alias du DAO&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public static final String ALIAS_NAME = "</xsl:text>
		<xsl:value-of select="dao/interface/bean-name"/>
		<xsl:text>1";&#13;&#13;</xsl:text>

		<xsl:if test="dao[class/customizable='true']">
			<xsl:text>	/**&#13;</xsl:text>
			<xsl:text>	 * Table qui stocke les champs personnalisées associés à ce DAO&#13;</xsl:text>
			<xsl:text>	 */&#13;</xsl:text>
			<xsl:text>	public static final String CUSTOM_FIELD_TABLE_NAME = "</xsl:text>
			<xsl:value-of select="parameters/parameter[@name='custom_field_table']"/>
			<xsl:text>";&#13;&#13;</xsl:text>

			<xsl:text>	/**&#13;</xsl:text>
			<xsl:text>	 * Table qui stocke la valeur des champs personnalisées associés à ce DAO&#13;</xsl:text>
			<xsl:text>	 */&#13;</xsl:text>
			<xsl:text>	public static final String CUSTOM_VALUE_TABLE_NAME = "</xsl:text>
			<xsl:value-of select="parameters/parameter[@name='custom_value_table']"/>
			<xsl:text>";&#13;&#13;</xsl:text>
		</xsl:if>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Tableau de clés primaires&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@SuppressWarnings("unchecked")&#13;</xsl:text>
		<xsl:text>	public static final PairValue&lt;Field, SqlType&gt;[] PK_FIELDS = new PairValue[] {</xsl:text>
		<xsl:apply-templates select="dao/class/identifier/attribute/field | dao/class/identifier/association/field" mode="declare-pkfield">
			<xsl:with-param name="entity" select="dao/interface/name" />
		</xsl:apply-templates>
		<xsl:text>};&#13;&#13;</xsl:text>

		<xsl:apply-templates select="dao/class/descendant::association[(@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association)]" mode="declare-fkfield">
			<xsl:with-param name="entity" select="dao/interface/name" />
		</xsl:apply-templates>

		<xsl:apply-templates select="dao[class/@join-class = 'true']" mode="joinclass-fk-2"/>

		<xsl:variable name="fields" select="dao/class/identifier/attribute/field | dao/class/attribute/field | dao/class/identifier/association/field | dao/class/association/field"/>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Number of fields&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public static final int NB_FIELDS = </xsl:text>
		<xsl:value-of select="count($fields)"/>
		<xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="field" mode="declare-pkfield">
		<xsl:param name="entity"/>

		<xsl:text>new PairValue&lt;Field, SqlType&gt;( </xsl:text>
		<xsl:value-of select="$entity"/>
		<xsl:text>Field.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:value-of select="@name"/>
		<xsl:text>, SqlType.</xsl:text>
		<xsl:value-of select="@jdbc-type"/>
		<xsl:text>)</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="association" mode="declare-fkfield">
		<xsl:param name="entity"/>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Tableau de clés étrangéres pour l'association </xsl:text><xsl:value-of select="@name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@SuppressWarnings("unchecked")&#13;</xsl:text>
		<xsl:text>	public static final PairValue&lt;Field,SqlType&gt;[] FK_</xsl:text><xsl:value-of select="@cascade-name"/><xsl:text> = new PairValue[] {&#13;</xsl:text>
		<xsl:apply-templates select="field" mode="declare-fkfield">
			<xsl:with-param name="entity" select="$entity" />
		</xsl:apply-templates>
		<xsl:text>	};&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="field" mode="declare-fkfield">
		<xsl:param name="entity"/>

		<xsl:text>new PairValue&lt;Field, SqlType&gt;(</xsl:text>
		<xsl:value-of select="$entity"/>
		<xsl:text>Field.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/>
		<xsl:text>)</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="dao-interface" mode="methods">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de sélection des entités (pour qu'elle puisse être modifiée)&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête de sélection des entités&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public DaoQuery getSelectDaoQuery();&#13;</xsl:text>

		<xsl:if test="count(dao/class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
			<xsl:text>	/**&#13;</xsl:text>
			<xsl:text>	 * Renvoie un clone de la requête de sélection des identifiants (pour qu'elle puisse être modifiée)&#13;</xsl:text>
			<xsl:text>	 *&#13;</xsl:text>
			<xsl:text>	 * @return un clone de la requête de sélection des identifiants&#13;</xsl:text>
			<xsl:text>	 */&#13;</xsl:text>
			<xsl:text>	public DaoQuery getSelectIdDaoQuery();&#13;&#13;</xsl:text>
		</xsl:if>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de comptage (pour qu'elle puisse être modifiée)&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête de comptage&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public DaoQuery getCountDaoQuery();&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête d'insertion (pour qu'elle puisse être modifiée)&#13;</xsl:text>
		<xsl:text>	 *&#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête d'insertion&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public SqlInsert getInsertQuery();&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête d'update (pour qu'elle puisse être modifiée)&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @return un clone de la requête d'update&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public SqlUpdate getUpdateQuery();&#13;&#13;</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Renvoie un clone de la requête de suppression (pour qu'elle puisse être modifiée)&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @return renvoie un clone de la requête de suppression&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public SqlDelete getDeleteQuery();&#13;&#13;</xsl:text>

		<xsl:apply-templates select="." mode="get-by-pk"/>
		<xsl:apply-templates select="." mode="get-list"/>
		<xsl:apply-templates select="." mode="get-list-id"/>

		<xsl:apply-templates select="." mode="save-or-update"/>
		<xsl:apply-templates select="." mode="save-or-update-list"/>
		<xsl:apply-templates select="." mode="save"/>
		<xsl:apply-templates select="." mode="savelist"/>
		<xsl:apply-templates select="." mode="update"/>
		<xsl:apply-templates select="." mode="updatelist"/>

		<xsl:apply-templates select="." mode="delete-by-pk"/>
		<xsl:apply-templates select="." mode="delete-list"/>

		<xsl:apply-templates select="." mode="get-nb"/>

		<xsl:apply-templates select="." mode="delete-cascade-getter"/>

		<xsl:apply-templates select="dao/method-signature"/>

		<xsl:if test="dao/class[@join-class = 'true']">
			<xsl:apply-templates select="." mode="joinclass-interface"/>

			<xsl:apply-templates select="." mode="join-class-insert-from-side">
				<xsl:with-param name="interface" select="dao/interface"/>
				<xsl:with-param name="joinclass" select="dao/class"/>
				<xsl:with-param name="class1" select="dao/class/../left-class"/>
				<xsl:with-param name="class2" select="dao/class/../right-class"/>
				<xsl:with-param name="asso1" select="dao/class/right-association"/>
				<xsl:with-param name="asso2" select="dao/class/left-association"/>
				<xsl:with-param name="masterclass" select="dao/class/../left-class"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="." mode="join-class-insert-from-side">
				<xsl:with-param name="interface" select="dao/interface"/>
				<xsl:with-param name="joinclass" select="dao/class"/>
				<xsl:with-param name="class1" select="dao/class/../right-class"/>
				<xsl:with-param name="class2" select="dao/class/../left-class"/>
				<xsl:with-param name="asso1" select="dao/class/left-association"/>
				<xsl:with-param name="asso2" select="dao/class/right-association"/>
				<xsl:with-param name="masterclass" select="dao/class/../left-class"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
