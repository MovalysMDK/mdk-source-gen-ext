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
<xsl:include href="includes/dao-cascadesaveupdate.xsl"/>
<xsl:include href="includes/dao-deletebypk.xsl"/>
<xsl:include href="includes/dao-deletelist.xsl"/>
<xsl:include href="includes/dao-getbypk.xsl"/>
<xsl:include href="includes/dao-getby-id-or-reference-interface.xsl"/>
<xsl:include href="includes/dao-getlist.xsl"/>
<xsl:include href="includes/dao-getlist-id.xsl"/>
<xsl:include href="includes/dao-getnb.xsl"/>
<xsl:include href="includes/dao-joinclass.xsl"/>
<xsl:include href="includes/dao-save-or-update.xsl"/>
<xsl:include href="includes/dao-save-or-update-list.xsl"/>
<xsl:include href="includes/dao-exist.xsl"/>
<xsl:include href="includes/dao-save.xsl"/>
<xsl:include href="includes/dao-savelist.xsl"/>
<xsl:include href="includes/dao-update.xsl"/>
<xsl:include href="includes/dao-updatelist.xsl"/>
<xsl:include href="includes/dao-valueobject.xsl"/>

<xsl:include href="includes/dao-deleteby-interface.xsl"/>
<xsl:include href="includes/dao-getby-interface.xsl"/>
<xsl:include href="includes/dao-getlistby-interface.xsl"/>
<xsl:include href="includes/dao-getnbby-interface.xsl"/>
<xsl:include href="includes/dao-sql.xsl"/>

<xsl:output method="text"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="dao-interface">

<xsl:variable name="dao" select="dao"/>
<xsl:variable name="interface" select="dao/interface"/>
<xsl:variable name="class" select="dao/class"/>
	
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import java.util.ArrayList;
<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableBOEntity']) > 0">
import java.util.List;
</xsl:if>
import java.util.Map;

<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.BeanAutowired;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.Public;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOList ;
<xsl:if test="$class/@join-class = 'true'">import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOListImpl;</xsl:if>
<!-- <xsl:if test="$class/implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']">import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MLiving;</xsl:if> -->
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.service.context.ItfTransactionalContext ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoException;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoQuery;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.DaoSession;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.Field;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.MEntityDao;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.PairValue;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.SqlType ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlInsert;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlUpdate;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.data.dao.query.SqlDelete;

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * 
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Interface de DAO : ]]></xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@SuppressWarnings("unchecked")
public interface <xsl:value-of select="name"/> extends MEntityDao&lt;<xsl:value-of select="$interface/name"/>&gt; {

	/**
	 * Table du DAO
	 */
	public static final String TABLE_NAME = "<xsl:value-of select="$class/table-name"/>";

	/**
	 * Alias du DAO
	 */
	public static final String ALIAS_NAME = "<xsl:value-of select="dao/interface/bean-name"/>1";

	<xsl:for-each select="$class/descendant::attribute">
		<xsl:if test="parent::class or parent::identifier">
			<xsl:if test="count(field/sequence) != 0 ">
	/**
	 * Sequence
	 */
	public static final String <xsl:value-of select="field/sequence/@name"/> = "<xsl:value-of select="field/sequence/@name"/>";
			</xsl:if>
		</xsl:if>
	</xsl:for-each>

	<!--  génération du tableau qui décrit la clé primaire -->
	/**
	 * Tableau de clés primaires
	 */
	public static final PairValue&lt;Field,SqlType&gt;[] PK_FIELDS = new PairValue[] {<xsl:for-each select="$class/identifier/attribute/field | $class/identifier/association/field">
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="@cascade-name"/>
			<xsl:value-of select="@name"/>, SqlType.<xsl:value-of select="@jdbc-type"/><xsl:text>)</xsl:text>
			<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each><xsl:text>
	};</xsl:text>


	<!--  génération des tableaux qui décrivent les clé étrangéres -->
	<xsl:for-each select="dao/class/descendant::association[(@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association)]">
	/**
	 * Tableau de clés étrangéres pour l'association <xsl:value-of select="@name"/>
	 */
	public static final PairValue&lt;Field,SqlType&gt;[] FK_<xsl:value-of select="@cascade-name"/>
		<xsl:text> = new PairValue[] {
		</xsl:text>
		<xsl:for-each select="field">
			new PairValue&lt;Field,SqlType&gt;( <xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text><xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
			<xsl:text>,
			</xsl:text>
			</xsl:if></xsl:for-each>
		<xsl:text>};</xsl:text>
	</xsl:for-each>


	<!-- spécifique join class : génération des tableaux qui décrivent les clé étrangères -->
	<xsl:if test="$class[@join-class = 'true']">
		<xsl:call-template name="dao-joinclass-fk-2">
			<xsl:with-param name="dao" select="dao"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:variable name="fields" select="$class/identifier/attribute/field | $class/attribute/field | $class/identifier/association/field | $class/association/field"/>

	/**
	 * Number of fields
	**/
	public static final int NB_FIELDS = <xsl:value-of select="count($fields)"/> ;
	
	/**
	 * Number of i18n fields
	**/
	public static final int NB_I18N_FIELDS = <xsl:value-of select="count($fields[../@type-short-name = 'I18nValue'])"/> ;


<xsl:text disable-output-escaping="yes"><![CDATA[	/**
	 * Enumération des champs
	 */]]></xsl:text><!-- génération de l'énumeration des champs -->
	@Public	 
	public enum <xsl:value-of select="$interface/name"/><xsl:text>Field implements Field {</xsl:text>	
	<xsl:for-each select="$class/identifier/attribute/field | $class/attribute/field | $class/identifier/association/field | $class/association/field">
		/**
		 * Field <xsl:value-of select="@name"/>
		 * type=<xsl:value-of select="@type"/> not-null=<xsl:value-of select="@not-null"/>
		 */
		<xsl:value-of select="@name"/>(<xsl:value-of select="position()"/>
		<xsl:if test="../@type-short-name = 'I18nValue'">
			<xsl:text>, true</xsl:text>
		</xsl:if>
		<xsl:text>)</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text> ,</xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text> ;</xsl:text>
		</xsl:if>
	</xsl:for-each>		
		/**
		 * Index de la column
		 */
		private int columnIndex ;

		/**
		 * Champs i18n ou pas
		 */		
		private boolean i18n ;
		
		/**
		 * Constructeur
		 * @param p_iColumnIndex index de la column
		 */
		private <xsl:value-of select="$interface/name"/>Field( int p_iColumnIndex ) {
			this.columnIndex = p_iColumnIndex ;
			this.i18n = false ;
		}
		
		/**
		 * Constructeur
		 * @param p_iColumnIndex index de la column
		 */
		private <xsl:value-of select="$interface/name"/>Field(int p_iColumnIndex, boolean p_bI18n) {
			this.columnIndex = p_iColumnIndex;
			this.i18n = p_bI18n ;
		}
		
		/**
		 * Retourne l'index de la colonne
		 * @return index de la colonne
		 */
		public int getColumnIndex() {
			return this.columnIndex ;
		}
		
		/**
		 * Retourne l'objet i18n
		 * @return Objet i18n
		 */
		public boolean isI18n() {
			return this.i18n;
		}
	}

	<xsl:for-each select="dao-bean-ref">
	@BeanAutowired(required=true)
	protected <xsl:value-of select="@type-short-name"/>
	<xsl:text> </xsl:text><xsl:value-of select="@name"/> ;
	</xsl:for-each>

	/**
	 * Renvoie un clone de la requête de sélection des entités (pour qu'elle puisse être modifiée)
	 *
	 * @return un clone de la requête de sélection des entités
	 */
	@Public
	public DaoQuery getSelectDaoQuery();
	
	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableBOEntity']) > 0">
	/**
	 * Renvoie un clone de la requête de sélection des identifiants (pour qu'elle puisse être modifiée)
	 *
	 * @return un clone de la requête de sélection des identifiants
	 */
	public DaoQuery getSelectIdDaoQuery();
	</xsl:if>
	/**
	 * Renvoie un clone de la requête de comptage (pour qu'elle puisse être modifiée)
	 *
	 * @return un clone de la requête de comptage
	 */
	@Public	 
	public DaoQuery getCountDaoQuery();

	/**
	 * Renvoie un clone de la requête d'insertion (pour qu'elle puisse être modifiée)
	 *
	 * @return un clone de la requête d'insertion
	 */
	public SqlInsert getInsertQuery();

	/**
	 * Renvoie un clone de la requête d'update (pour qu'elle puisse être modifiée)
	 *
	 * @return un clone de la requête d'update
	 */
	public SqlUpdate getUpdateQuery();
	
	/**
	 * Renvoie un clone de la requête de suppression (pour qu'elle puisse être modifiée)
	 *
	 * @return renvoie un clone de la requête de suppression
	 */
	public SqlDelete getDeleteQuery();

	<xsl:call-template name="dao-getbypk-interface"/>
	<xsl:call-template name="dao-getlist-interface"/>
	<xsl:call-template name="dao-getlist-id-interface"/>
	
	<xsl:call-template name="dao-interface-getby-id-or-reference"/>
	
	<xsl:call-template name="dao-save-or-update-interface"/>
	<xsl:call-template name="dao-save-or-update-list-interface"/>
	
	<xsl:call-template name="dao-deletebypk-interface"/>
	<xsl:call-template name="dao-deletelist-interface"/>
	
	<xsl:call-template name="dao-getnb-interface"/>
	
	<xsl:apply-templates select="dao/method-signature"/>
	
	<xsl:if test="$class[@join-class = 'true']">
		<xsl:call-template name="dao-joinclass-interface"/>
		
		<xsl:call-template name="dao-joinclass-insertfromside-interface">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="joinclass" select="$class"/>
			<xsl:with-param name="class1" select="$class/../left-class"/>
			<xsl:with-param name="class2" select="$class/../right-class"/>
			<xsl:with-param name="asso1" select="$class/right-association"/>
			<xsl:with-param name="asso2" select="$class/left-association"/>
			<xsl:with-param name="masterclass" select="$class/../left-class"/>
		</xsl:call-template>
		
		<xsl:call-template name="dao-joinclass-insertfromside-interface">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="joinclass" select="$class"/>
			<xsl:with-param name="class1" select="$class/../right-class"/>
			<xsl:with-param name="class2" select="$class/../left-class"/>
			<xsl:with-param name="asso1" select="$class/left-association"/>
			<xsl:with-param name="asso2" select="$class/right-association"/>
			<xsl:with-param name="masterclass" select="$class/../left-class"/>
		</xsl:call-template>	
	</xsl:if>

//@non-generated-start[methods]
<xsl:value-of select="non-generated/bloc[@id='methods']"/>
<xsl:text>//@non-generated-end</xsl:text>

}</xsl:template>

<xsl:template match="method-signature">
	//MMA ATTENTION!!
</xsl:template>

</xsl:stylesheet>
