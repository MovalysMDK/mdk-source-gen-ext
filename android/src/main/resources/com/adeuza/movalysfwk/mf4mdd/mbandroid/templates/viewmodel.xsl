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

	<xsl:include href="includes/class.xsl"/>
	<xsl:include href="includes/string-replace-all.xsl"/>
	
	<xsl:include href="ui/viewmodel/import.xsl"/>
	<xsl:include href="ui/viewmodel/attribute-declaration.xsl"/>
	<xsl:include href="ui/viewmodel/attribute-getter-setter.xsl"/>
	<xsl:include href="ui/viewmodel/update-from-identifiable.xsl"/>
	<xsl:include href="ui/viewmodel/attribute-derived.xsl"/>
	
	<xsl:include href="ui/viewmodel/update-from-dataloader.xsl"/>
	<xsl:include href="ui/viewmodel/clear.xsl"/>
	<xsl:include href="ui/viewmodel/key-constants.xsl"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="viewmodel">
		<xsl:apply-templates select="." mode="declare-class"/>
	</xsl:template>

	<!-- SUPERCLASS ................................................................................................. -->

	
	<xsl:template match="viewmodel[type/name='MASTER' and workspace-vm='true']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="viewmodel[type/name='MASTER' and workspace-vm='false' or type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[(type/name='MASTER' and workspace-vm='false' or type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3') and customizable='true' ]" mode="superclass">
		<xsl:text>AbstractCustomizableViewModel&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_3']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='STD']" mode="superclass">
		<xsl:choose>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_id'">
				<xsl:text>AbstractItemViewModelId</xsl:text>
			</xsl:when>
			<xsl:when test="./identifier/descendant::attribute[1]/@name='id_identifier'">
				<xsl:text>AbstractItemViewModelIdentifier</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractItemViewModel</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel[not(entity-to-update)]" mode="superclass">
		<xsl:text>AbstractViewModel</xsl:text>
	</xsl:template>
	
	<!-- ATTRIBUTES ................................................................................................. -->

	<xsl:template match="viewmodel" mode="attributes">
		<!-- Génération des constants du ViewModel -->
		<xsl:apply-templates select="." mode="generate-constant-declaration"/>
	
		<!-- Génération des attributs du viewmodel -->
<!-- 		<xsl:apply-templates select="." mode="generate-specific-attribute"/> -->
	
		<!-- Génération des attributs du viewmodel -->
		<xsl:apply-templates select="./identifier/attribute[not(@name='id_id') and not(@name='id_identifier')]|attribute" mode="generate-attribute-declaration"/>

		<!-- Génération d'attributs représentant les viewmodels liés -->
		<xsl:apply-templates select="subvm/viewmodel|.//external-lists/external-list/viewmodel" mode ="generate-attributes"/>
	</xsl:template>
	
<!-- 	<xsl:template match="viewmodel[type/name='LISTITEM_1'] and widget-variant='mdkwidget'" mode="generate-specific-attribute"> -->

<!-- 		/** -->
<!-- 		 * Generated view model for presenter view -->
<!-- 		 */ -->
<!-- 		 <xsl:text>MDKPresenter o</xsl:text><xsl:value-of select="uml-name"/> -->
<!-- 		 <xsl:text> = new MDKPresenter();</xsl:text> -->
<!-- 	</xsl:template> -->
	
<!-- 	<xsl:template match="*" mode="generate-specific-attribute"> -->
<!-- 	</xsl:template> -->
	
	<!-- Attribute declaration (non-derived attribute) -->
	<xsl:template match="attribute[@derived='false']" mode="generate-attribute-declaration">
	
		/**
		 * <xsl:value-of select="documentation/doc-attribute"/>
		 * <xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>
		 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		 *<xsl:text> </xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text> type=</xsl:text>
			<xsl:value-of select="@type-short-name"/>
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@nullable = 'false'"/>
			<xsl:if test="@unique and @unique='true'">
				<xsl:text> unique=</xsl:text>
				<xsl:value-of select="@unique and @unique='true'"/>
			</xsl:if>
			<xsl:if test="@unique-key">	
				<xsl:variable name="unique-key" select="@unique-key"/>
				<xsl:text> unique-key=true</xsl:text>
				<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
				<xsl:text> unique-key-relation=</xsl:text>
				
				<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and field/@name!=$name] | //pojo/class/attribute[@unique-key=$unique-key and field/@name!=$name]">
					<xsl:value-of select="field/@name"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		*/<xsl:variable name="attribute" select="concat('attribute-', @name)"/>
		//@non-generated-start[attribute-<xsl:value-of select="@name"/>]
			<xsl:value-of select="/class/non-generated/bloc[@id=$attribute]"/>
			<xsl:text>//@non-generated-end[attribute-</xsl:text><xsl:value-of select="@name"/>]
		<xsl:value-of select="@visibility"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@type-short-name"/>
			<xsl:if test="@contained-type-short-name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="@contained-type-short-name"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/> ;
	</xsl:template>

	<!-- Attribute declaration (derived attribute) -->
	<xsl:template match="attribute[@derived='true']" mode="generate-attribute-declaration">
		<!-- Nothing to do but but do not remove template -->
		/**	
		 * Derived attribute <xsl:value-of select="@name"/>
		 * <xsl:value-of select="documentation/doc-attribute"/> 
		 */
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId" select="@name"/>
			<xsl:with-param name="defaultSource">
				<xsl:value-of select="@visibility"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@type-short-name"/>
				<xsl:if test="@contained-type-short-name">
					<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="@contained-type-short-name"/>
					<xsl:text>&gt;</xsl:text>
				</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/> ;
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>





	<!-- CONSTRUCTORS ............................................................................................... -->

	<xsl:template match="viewmodel[read-only='true']" mode="constructors">

		/**
		 * Default constructor.
		 */
		public <xsl:value-of select="name"/>() {
			this.setEditable(false);
		}
	</xsl:template>

	<!-- METHODS .................................................................................................... -->

	<xsl:template match="viewmodel" mode="methods">
	
		<xsl:apply-templates select="identifier/attribute[not(@name='id_id') and not(@name='id_identifier')]|attribute" mode="generate-attribute-get-and-set" />
		
		<xsl:apply-templates select="subvm/viewmodel|.//external-lists/external-list/viewmodel" mode="generate-getters"/>
		<xsl:apply-templates select="subvm/viewmodel|.//external-lists/external-list/viewmodel" mode="generate-setters"/>
		<xsl:if test="entity-to-update">
			<xsl:apply-templates select="." mode="generate-identifiable"/>
		</xsl:if>
		<xsl:apply-templates select="mapping" mode="generate-method-clear"/>
		<xsl:apply-templates select="." mode="generate-method-getIdVM"/>
		
		<xsl:apply-templates select="." mode="generate-calc-method" />
		
	</xsl:template>

	<!-- GETTERS ............................................................................................ -->

	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Returns the fixedlist view model </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; </xsl:text><xsl:value-of select="list-accessor-get-name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>	return this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;	}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-getters">
		<!-- Méthode de récupération du viewmodel sélectionné -->
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * Returns the combo selected item view model </xsl:text>
		<xsl:text>o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text><xsl:text>o</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="./accessor-get-name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>	return this.o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;	}&#13;&#13;</xsl:text>

		<!-- Méthode de récupération de la liste des viewmodels utilisée par la combo -->
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * returns the combo view model </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; </xsl:text><xsl:value-of select="list-accessor-get-name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>	return this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;	}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-getters">
		<!-- Méthode de récupération de la liste des viewmodels utilisée par la combo -->
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * returns the combo view model </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; </xsl:text><xsl:value-of select="list-accessor-get-name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>	return this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;	}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[workspace-vm='false']/subvm/viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_3' or type/name='LISTITEM_2']" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * returns the list view model </xsl:text>
		<xsl:text>lst</xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text><xsl:text>lst</xsl:text><xsl:value-of select="./name"/><xsl:text>&#13;</xsl:text>
		<xsl:text>lst</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		public <xsl:value-of select="./type/list"/><xsl:text>&lt;</xsl:text>
			<xsl:value-of select="./entity-to-update/name"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="./implements/interface/@name"/><xsl:text>&gt; </xsl:text>
			<xsl:value-of select="list-accessor-get-name"/>() {
			return this.lst<xsl:value-of select="./name"/>;
		}
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-getters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * returns the sub view model </xsl:text>
		<xsl:text>o</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> * @return the value of </xsl:text>
		<xsl:text>o</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="accessor-get-name"/>
		<xsl:text>() {&#13;</xsl:text>
		<xsl:text>return this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>;&#13;}&#13;</xsl:text>
	</xsl:template>

	<!-- SETTERS ............................................................................................ -->

	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the fixedlist view model.&#13;</xsl:text>
		<xsl:text> * @param p_lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> fixedlist view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="list-accessor-set-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; p_lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>) {&#13;</xsl:text>
		
		
		<xsl:text>if (this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> != p_lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>) {&#13;Object sOldVal = this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> = p_lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;this.notifyFieldChanged(</xsl:text>
		<xsl:variable name="varName">lst<xsl:value-of select="implements/interface/@name"/></xsl:variable>		
		<xsl:text>KEY_</xsl:text><xsl:value-of select="translate($varName, $smallcase, $uppercase)"/>
		<xsl:text>, sOldVal, p_lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>);</xsl:text>
		<xsl:text>&#13;}&#13;}&#13;&#13;</xsl:text>
					
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the combo selected item view model.&#13;</xsl:text>
		<xsl:text> * @param p_o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> combo selected item view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="accessor-set-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> p_o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>) {&#13;</xsl:text>
		<xsl:text>if (this.o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> != p_o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>) {&#13;Object sOldVal = this.o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;this.o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> = p_o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;this.notifyFieldChanged(</xsl:text>
		<xsl:variable name="varName"><xsl:value-of select="implements/interface/@name"/></xsl:variable>		
		<xsl:text>KEY_</xsl:text><xsl:value-of select="translate($varName, $smallcase, $uppercase)"/>
		<xsl:text>, sOldVal, p_o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>);</xsl:text>
		<xsl:text>&#13;}&#13;}&#13;&#13;</xsl:text>
		
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the combo view model.&#13;</xsl:text>
		<xsl:text> * @param p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s combo view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="list-accessor-set-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s) {&#13;</xsl:text>
		<xsl:text>	this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> = p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s;&#13;}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the combo view model.&#13;</xsl:text>
		<xsl:text> * @param p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s combo view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="list-accessor-set-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s) {&#13;</xsl:text>
		<xsl:text>	this.lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> = p_list</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>s;&#13;}&#13;&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel[workspace-vm='false']/subvm/viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3']" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the list view model.&#13;</xsl:text>
		<xsl:text> * @param p_oData</xsl:text>
		<xsl:text> list view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="list-accessor-set-name"/>
		<xsl:text>(</xsl:text><xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; p_oData) {</xsl:text>
			this.lst<xsl:value-of select="./name"/> = p_oData;
			this.lst<xsl:value-of select="./name"/>.setParent(this);
		}
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-setters">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * sets the sub view model.&#13;</xsl:text>
		<xsl:text> * @param p_oData</xsl:text>
		<xsl:text> sub view model&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public void </xsl:text>
		<xsl:value-of select="accessor-set-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> p_oData) {&#13;</xsl:text>
		<xsl:text>this.o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = p_oData;&#13;}&#13;</xsl:text>
	</xsl:template>

	<!-- IDENTIFIABLE ............................................................................. -->

	<xsl:template match="mapping" mode="generate-method-modify">
		<xsl:text>if (p_oEntity != null) {&#13;</xsl:text>
		<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify"/>
		<xsl:apply-templates select="entity[setter]" mode="generate-method-modify"/>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">modify-to-identifiable</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="@type"/>
		</xsl:variable>

		<xsl:if test=".//attribute/setter">
			<xsl:text>{&#13;</xsl:text>
			
			<xsl:variable name="updateVariable">
				<xsl:text>bUpdate</xsl:text>
				<xsl:value-of select="@type"/>
			</xsl:variable>
			
			<xsl:value-of select="@type"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$var-entity"/>
			<xsl:text> = </xsl:text>
			<xsl:value-of select="$var-parent-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="getter/@name"/>
			<xsl:text>();&#13;</xsl:text>
			
			<xsl:if test="@mandatory = 'false'">
				<xsl:text>boolean </xsl:text>
				<xsl:value-of select="$updateVariable"/>
				<xsl:text> = </xsl:text>
				<xsl:value-of select="$var-entity"/>
				<xsl:text> != null || (</xsl:text>
				<xsl:apply-templates select=".//attribute" mode="testEntityFieldsValued"/>
				<xsl:text>);&#13;</xsl:text>
			</xsl:if>
			
			<xsl:text>if (</xsl:text>
			<xsl:if test="@mandatory = 'false'">
				<xsl:value-of select="$updateVariable"/>
				<xsl:text disable-output-escaping="yes"> <![CDATA[&&]]> </xsl:text>
			</xsl:if>
			<xsl:value-of select="$var-entity"/>
			<xsl:text> == null) {&#13;</xsl:text>
			<xsl:value-of select="$var-entity"/>
			<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
			<xsl:value-of select="setter/@factory"/>
			<xsl:text>.class).createInstance();&#13;</xsl:text>
			<xsl:value-of select="$var-parent-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="setter/@name"/>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="$var-entity"/>
			<xsl:text>);&#13;}&#13;</xsl:text>

			<xsl:if test="@mandatory = 'false'">
				<xsl:text>if (</xsl:text>
				<xsl:value-of select="$updateVariable"/>
				<xsl:text>) {&#13;</xsl:text>
			</xsl:if>

			<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify">
				<xsl:with-param name="var-entity" select="$var-entity"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="entity" mode="generate-method-modify">
				<xsl:with-param name="var-parent-entity" select="$var-entity"/>
			</xsl:apply-templates>

			<xsl:if test="@mandatory = 'false'">
				<xsl:text>}&#13;</xsl:text>
			</xsl:if>

			<xsl:text>&#13;}&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="attribute" mode="testEntityFieldsValued">
		<!-- si ce n'est pas ni le premier element non primitif et qu'il n'est pas primitif -->
		<xsl:if test="position() > 1">
			<xsl:text>|| </xsl:text>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="vm-attr-initial-value/@primitive='true' or vm-attr-initial-value='null'">
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="@vm-attr"/>
				<xsl:text> != </xsl:text>
				<xsl:value-of select="vm-attr-initial-value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>!</xsl:text>
				<xsl:value-of select="vm-attr-initial-value"/>
				<xsl:text>.equals(this.</xsl:text>
				<xsl:value-of select="@vm-attr"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>


	<xsl:template match="entity[@mapping-type='vmlist' and setter]" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>

		<xsl:text>if (this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> != null) {&#13;</xsl:text>

		<xsl:variable name="var-list">
			<xsl:text>list</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:variable name="var-map">
			<xsl:text>map</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
			<xsl:text>ById</xsl:text>
		</xsl:variable>


		<xsl:text>List&lt;</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>();&#13;</xsl:text>

		<xsl:text>Map&lt;String, </xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:value-of select="$var-map"/>
		<xsl:text> = new TreeMap&lt;String,</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>&gt;();&#13;</xsl:text>

		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text> == null) {&#13;</xsl:text>

		<xsl:value-of select="$var-list"/>
		<xsl:text> = new ArrayList&lt;</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>&gt;();&#13;</xsl:text>

		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text>);&#13;</xsl:text>

		<xsl:text>}&#13; else {&#13;</xsl:text>

		<xsl:text>for(</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text>) {&#13;</xsl:text>
		<xsl:value-of select="$var-map"/>
		<xsl:text>.put(o</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>.idToString(), o</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>);&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text>.clear();&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>

		<xsl:value-of select="setter/@factory"/>
		<xsl:text> oFactory = BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="setter/@factory"/>
		<xsl:text>.class);&#13;</xsl:text>

		<xsl:value-of select="@type"/>
		<xsl:text> oSubEntity = null;&#13;</xsl:text>

		<xsl:text>for (int iIndex = 0 ; iIndex &lt; this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>.getCount() ; iIndex++) {&#13;</xsl:text>
		<xsl:value-of select="@vm-type"/>
		<xsl:text> oVM = this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>.getCacheVMByPosition(iIndex);&#13;</xsl:text>
		<xsl:text>oSubEntity = </xsl:text>
		<xsl:value-of select="$var-map"/>
		<xsl:text>.get(oVM.getIdVM());&#13;</xsl:text>
		<xsl:text>if (oSubEntity == null) {&#13;</xsl:text>
		<xsl:text>oSubEntity = oFactory.createInstance();&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>oVM.modifyToIdentifiable(oSubEntity);&#13;</xsl:text>
		<xsl:value-of select="$var-list"/>
		<xsl:text>.add(oSubEntity);&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vm' or @mapping-type='vm_comboitemselected']" mode="generate-method-modify">
		<xsl:param name="var-parent-entity">p_oEntity</xsl:param>

		<xsl:text>if (this.</xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text> == null) {&#13;</xsl:text>

		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(null);&#13;</xsl:text>

		<xsl:text>} else {&#13;</xsl:text>

		<xsl:variable name="entityToUpdate"><xsl:text>o</xsl:text><xsl:value-of select="@type"/></xsl:variable>
		<xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="$entityToUpdate"/>
		<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="setter/@factory"/><xsl:text>.class).createInstance();&#13;</xsl:text>
        <xsl:text>this.</xsl:text><xsl:value-of select="@vm-attr"/>
        <xsl:text>.modifyToIdentifiable(</xsl:text>
        <xsl:value-of select="$entityToUpdate"/>
        <xsl:text>);&#13;</xsl:text>
        
        <xsl:value-of select="$var-parent-entity"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="setter/@name"/>
        <xsl:text>(</xsl:text><xsl:value-of select="$entityToUpdate"/><xsl:text>);&#13;</xsl:text>

		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="attribute[setter]" mode="generate-method-modify">
		<xsl:param name="var-entity">p_oEntity</xsl:param>

		<xsl:value-of select="$var-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="setter/@formula">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="setter/@formula"/>
					<xsl:with-param name="replace" select="'VALUE'"/>
					<xsl:with-param name="by">
						<xsl:text>this.</xsl:text>
						<xsl:value-of select="@vm-attr"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:text>this.</xsl:text>
				<xsl:value-of select="@vm-attr"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="attribute" mode="generate-method-modify">
		<xsl:text>// Pas de mise à jour de l'entité pour l'attribut </xsl:text>
		<xsl:value-of select="@vm-attr"/>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>

	<!-- GETIDVDM ............................................................................................ -->

	<xsl:template match="viewmodel" mode="generate-method-getIdVM"><!-- marche car dans ce cas là on sais pour le moment qu'on a qu'un seul élément -->
		<xsl:if test="./attribute/@type-short-name='List' or count(identifier/attribute) = 0">
			/**
			 * {@inheritDoc}
			 */
			@Override
			public String getIdVM() {
				return String.valueOf(this.hashCode());
			}
		</xsl:if>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LISTITEM_3' or type/name='LISTITEM_2']" mode="generate-method-getIdVM">
		/**
		 * {@inheritDoc}
		 */
		<xsl:text>@Override&#13;</xsl:text>	
		<xsl:text>public String getIdVM() {&#13;</xsl:text>
		<xsl:text>	return String.valueOf(</xsl:text>
		<xsl:choose>
			<xsl:when test="./attribute/@type-short-name!='List'">
				<xsl:text>this.</xsl:text><xsl:value-of select="./identifier/attribute/get-accessor"/><xsl:text>()</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>this.hashCode()</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>);&#13;}</xsl:text>


		<xsl:if test="count(./subvm/viewmodel)>0">
		/**
		 * {@inheritDoc}
		 */
		@Override
		public ListViewModel&lt;<xsl:value-of select="./subvm/viewmodel/entity-to-update/name"/>
		<xsl:text>, </xsl:text><xsl:value-of select="./subvm/viewmodel/implements/interface/@name"/>> getComposite() {
			<xsl:for-each select="./subvm/viewmodel">
			return this.<xsl:if test="string-length(./type/list)>0">lst</xsl:if><xsl:if test="string-length(./type/list)=0">o</xsl:if><xsl:value-of select="./name"/>;
			</xsl:for-each>
		}
		</xsl:if>
	</xsl:template>
	
	<!-- WORKSPACE = true AND IDENTIFIABLE ............................................................................................ -->
	<xsl:template match="viewmodel[workspace-vm='true']" mode="generate-identifiable">
		/**
		 * {@inheritDoc}
	 	 * @see com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ItemViewModel#modifyToIdentifiable(com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable)
		 */
		@Override
		public void modifyToIdentifiable(MIdentifiable p_oIdentifiable) {
			//@non-generated-start[modifyToIdentifiable-before]
			<xsl:value-of select="non-generated/bloc[@id='modifyToIdentifiable-before']"/>
			//@non-generated-end
			//@non-generated-start[modifyToIdentifiable-after]
			<xsl:value-of select="non-generated/bloc[@id='modifyToIdentifiable-after']"/>
			//@non-generated-end
		}
		
		/**
		 * {@inheritDoc}
	 	 * @see com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractItemViewModel#updateFromIdentifiable(com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable)
		 */
		@Override
		public void updateFromIdentifiable(MIdentifiable p_oIdentifiable) {
			//@non-generated-start[updateFromIdentifiable-before]
			<xsl:value-of select="non-generated/bloc[@id='updateFromIdentifiable-before']"/>
			//@non-generated-end
			//@non-generated-start[updateFromIdentifiable-after]
			<xsl:value-of select="non-generated/bloc[@id='updateFromIdentifiable-after']"/>
			//@non-generated-end
		}
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-identifiable">
		/**
		* {@inheritDoc}
		* @see com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ItemViewModel#modifyToIdentifiable(com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable)
		*/
		public void modifyToIdentifiable(<xsl:value-of select="./entity-to-update/name"/><xsl:text> p_oEntity) {&#13;</xsl:text>
			<xsl:if test="customizable='true'">super.modifyToIdentifiable(p_oEntity);</xsl:if>

			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">modifyToIdentifiable-before</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>

			<xsl:apply-templates select="mapping" mode="generate-method-modify"/>

			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">modifyToIdentifiable-after</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
		}
		
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.AbstractItemViewModel#updateFromIdentifiable(com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable)
		 */
		@Override
		public void updateFromIdentifiable(<xsl:value-of select="./entity-to-update/name"/><xsl:text> p_oEntity) {&#13;</xsl:text>
			<xsl:if test="customizable='true'">super.updateFromIdentifiable(p_oEntity);</xsl:if>
			
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromIdentifiable-notify-before</xsl:with-param>
				<xsl:with-param name="defaultSource">
					this.setAlwaysNotify(false);
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromIdentifiable-before</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
			
			<xsl:apply-templates select="mapping" mode="generate-method-update"/>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromIdentifiable-after</xsl:with-param>
				<xsl:with-param name="defaultSource"/>
			</xsl:call-template>
			this.computeEditableFlag();
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromIdentifiable-notify-after</xsl:with-param>
				<xsl:with-param name="defaultSource">
					this.setAlwaysNotify(true);
					this.doOnDataLoaded(null);
				</xsl:with-param>
			</xsl:call-template>
		}
		<xsl:apply-templates select="self::node()[dataloader-impl]" mode="generate-method-update-from-dataloader"/>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="generate-calc-method">
		<xsl:apply-templates select="attribute[@derived='true']" mode="derived-method"/>
	</xsl:template>

</xsl:stylesheet>
