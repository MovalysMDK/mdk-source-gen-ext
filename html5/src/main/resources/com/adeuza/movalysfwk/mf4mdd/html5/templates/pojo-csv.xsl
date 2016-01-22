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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8" />

	<xsl:variable name="majuscules">
		ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ
	</xsl:variable>
	<xsl:variable name="minuscules">
		abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ
	</xsl:variable>


	<!-- ****************************** -->
	<!-- *** csvGenerator : DIAGRAM *** -->
	<!-- ****************************** -->
	<xsl:template match="diagram">
		<xsl:apply-templates select="schema/table" mode="csvGeneratorTable" />
	</xsl:template>


	<!-- ************************************************ -->
	<!-- *** csvGeneratorTable : DIAGRAM/SCHEMA/TABLE *** -->
	<!-- ************************************************ -->
	<xsl:template match="table" mode="csvGeneratorTable">
		<xsl:if test="@join-table='false'">
			<xsl:call-template name="csvGeneratorClass">
				<xsl:with-param name="nameTable" select="@name" />
				<xsl:with-param name="cptTable"
					select="format-number((position()*10), '000')" />
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="@join-table='true'">
			<xsl:call-template name="csvGeneratorJoinClass">
				<xsl:with-param name="nameTable" select="@name" />
				<xsl:with-param name="cptTable"
					select="format-number((position()*10), '000')" />
			</xsl:call-template>
		</xsl:if>
		<!-- add composite attribute -->
		<xsl:variable name="tableName" select="@name" />
		<xsl:apply-templates select="/diagram/classes/class[table-name = $tableName]"
			mode="addCompositeAttribute">
			<xsl:with-param name="nameTable" select="$tableName" />
			<xsl:with-param name="cptTable"
				select="format-number((position()*10), '000')" />
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="class" mode="addCompositeAttribute">
		<xsl:param name="nameTable" />
		<xsl:param name="cptTable" />

		<xsl:if
			test="count( stereotypes/stereotype[@name = 'adjava_classFromExpandableAttributeStereotype'] ) = 0">
			<xsl:for-each select="attribute[@kind='composite']">
				<xsl:call-template name="csvGeneratorCompositeClass">
					<xsl:with-param name="nameTable" select="$nameTable" />
					<xsl:with-param name="cptTable"
						select="format-number($cptTable + position(), '000')" />
					<xsl:with-param name="compositeAttribute" select="." />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="csvGeneratorClassHeader">
		<xsl:param name="uml-name" />
		<xsl:param name="cptTable" />
		<xsl:param name="nameTable" />
		<!-- *** Entity *** -->
		<xsl:text>
Entity#</xsl:text>
		<xsl:value-of select="$uml-name" />

		<!-- *** Group *** -->
		<xsl:text>
Group#generated_model</xsl:text>

		<!-- *** Products *** -->
		<xsl:text>
Products#NAME_PRODUCT</xsl:text>

		<!-- *** FileName *** -->
		<xsl:text>
FileName#User</xsl:text>
		<xsl:value-of select="$cptTable" />
		<xsl:text>_</xsl:text>
		<xsl:choose>
			<xsl:when
				test="/diagram/classes/class[table-name=$nameTable]/@join-class ='true'">
				<xsl:value-of
					select="/diagram/classes/class[table-name=$nameTable]/left-association/real-name-for-join-class" />
				<xsl:text>-</xsl:text>
				<xsl:value-of
					select="/diagram/classes/class[table-name=$nameTable]/right-association/name" />
				<xsl:text>_</xsl:text>
				<xsl:value-of
					select="/diagram/classes/class[table-name=$nameTable]/right-association/real-name-for-join-class" />
				<xsl:text>-</xsl:text>
				<xsl:value-of
					select="/diagram/classes/class[table-name=$nameTable]/left-association/name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$uml-name" />
			</xsl:otherwise>
		</xsl:choose>
		<!-- *** Admable *** -->
		<xsl:text>
Admable#No</xsl:text>

		<!-- *** Title *** -->
		<xsl:text>
Title(fr_FR;en_EN)#</xsl:text>
		<xsl:value-of select="$uml-name" />
		<xsl:text>;</xsl:text>
		<xsl:value-of select="$uml-name" />

		<!-- *** Tab Title *** -->
		<xsl:text>
TabTitle(fr_FR;en_EN)#</xsl:text>
		<xsl:value-of select="$uml-name" />
		<xsl:text>;</xsl:text>
		<xsl:value-of select="$uml-name" />

	</xsl:template>

	<!-- ************************************************* -->
	<!-- *** csvGeneratorClass : DIAGRAM/CLASSES/CLASS *** -->
	<!-- ************************************************* -->
	<xsl:template name="csvGeneratorClass">
		<xsl:param name="nameTable" />
		<xsl:param name="cptTable" />

		<!-- Variable : Name Class -->
		<xsl:variable name="uml-name"
			select="/diagram/classes/class[table-name=$nameTable]/uml-name" />

		<xsl:call-template name="csvGeneratorClassHeader">
			<xsl:with-param name="uml-name" select="$uml-name" />
			<xsl:with-param name="cptTable" select="$cptTable" />
		</xsl:call-template>

		<xsl:variable name="isNotExpandableAttributeClass"
			select="boolean(count( /diagram/classes/class[table-name=$nameTable]/stereotypes/stereotype[@name = 'adjava_classFromExpandableAttributeStereotype'] )= 0)" />

		<!-- *** Name *** -->
		<xsl:text>
Name#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:value-of select="@name" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:value-of
					select="translate(concat(@name,'identifier'),$minuscules,$majuscules)" />
				<xsl:text>#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Module *** -->
		<xsl:text>
Module#</xsl:text>

		<!-- *** Label *** -->
		<xsl:text>
Label(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:value-of
					select="translate(concat(@name,'identifier'), $majuscules , $minuscules )" />
				<xsl:text>;</xsl:text>
				<xsl:value-of
					select="translate(concat(@name,'identifier'), $majuscules , $minuscules )" />
				<xsl:text>#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>

		<!-- *** Comment *** -->
		<xsl:text>
Comment(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>champ de type seq;champ de type seq#</xsl:text>
				</xsl:when>
				<xsl:when test="field/@data-type">
					<xsl:text>champ de type number;champ de type number#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:choose>
				<xsl:when test="sequence">
					<xsl:text>champ de type refseq; champ de type refseq#</xsl:text>
				</xsl:when>
				<xsl:when test="@data-type">
					<xsl:text>champ de type number;champ de type number#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvComment" />
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test="$isNotExpandableAttributeClass">
				<!-- on cree une seule colonne de lien vers un autre onglet -->
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
					<xsl:text>champ de type number;champ de type number#</xsl:text>
				</xsl:for-each>
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
					<xsl:text>champ hidden;champ hidden#</xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- on ajoute tous les attributs -->
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
					<xsl:apply-templates select="." mode="csvComment" />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

		<!-- *** VisualSize *** -->
		<xsl:text>
VisualSize#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>10#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:text>20#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvVisualSize" />
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test="$isNotExpandableAttributeClass">
				<!-- on cree une seule colonne de lien vers un autre onglet -->
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
					<xsl:text>15#</xsl:text>
				</xsl:for-each>
				<!-- on ajoute tous les attributs avec un size à 0 pour les cacher dans 
					la feuille excel et ne pas les saisir et exporter -->
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
					<xsl:text>0#</xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- on ajoute tous les attributs -->
				<xsl:for-each
					select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
					<xsl:apply-templates select="." mode="csvVisualSize" />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<!-- *** SQL Field *** -->
		<xsl:text>
SQL FIELD#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:value-of select="@name" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass"><!-- on ajoute tous les attributs -->
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:text>#</xsl:text><!-- pas de nom de colonne pour ne pas générer 
					l insert dans la colonne SQL -->
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property/field">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Mandatory *** -->
		<xsl:text>
Mandatory#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>yes#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association[count(field)>0]">
			<xsl:apply-templates select="." mode="csvMandatory" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvMandatory" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass"><!-- on ajoute tous les attributs -->
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:apply-templates select="." mode="csvMandatory" />
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvMandatory" />
		</xsl:for-each>

		<!-- *** Size *** -->
		<xsl:text>
Size#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:text>20#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!-- on ajoute tous les attributs -->
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>

		<!-- *** Type *** -->
		<xsl:text>
Type#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>seq#</xsl:text>
				</xsl:when>
				<xsl:when test="field/@data-type">
					<xsl:text>numberid#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:choose>
				<xsl:when test="sequence">
					<xsl:text>refseq#</xsl:text>
				</xsl:when>
				<!-- <xsl:when test="@data-type"><xsl:text>number#</xsl:text></xsl:when> -->
				<xsl:when
					test="../@type='many-to-one' or (../@type='one-to-one' and ../@relation-owner='true'  and ../@transient='false')">
					<xsl:text>ref1#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvType" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:text>ref1#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!-- on ajoute tous les attributs -->
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvType" />
		</xsl:for-each>

		<!-- *** Option *** -->
		<xsl:text>
Option#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="$nameTable" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:if
				test="../@type='many-to-one' or (../@type='one-to-one' and ../@relation-owner='true'  and ../@transient='false')">
				<xsl:variable name="nameClass" select="../@type-short-name" />
				<xsl:apply-templates select="/diagram/classes/class[uml-name=$nameClass]"
					mode="csvOptionType" />
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvOption" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:text>numberid#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!-- on ajoute tous les attributs -->
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvOption" />
		</xsl:for-each>

		<!-- *** Option2 *** -->
		<xsl:text>
Option2#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0] 
							and (@type-name='MFAddressLocation' or @type-name = 'MFPhoto')]">
				<xsl:text>include#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Unique *** -->
		<xsl:text>
Unique#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>yes#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:apply-templates select="." mode="csvUnique" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvUnique" />
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:text>yes#</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!-- on ajoute tous les attributs -->
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvUnique" />
		</xsl:for-each>

		<!-- *** I18N : NON GERE *** -->
		<xsl:text>
I18n#</xsl:text>

		<!-- *** ReferenceFrom *** -->
		<xsl:text>
Reference from#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:if
				test="../@type='many-to-one' or (../@type='one-to-one' and ../@relation-owner='true'  and ../@transient='false')">
				<xsl:variable name="nameClass" select="../@type-short-name" />
				<xsl:apply-templates select="/diagram/classes/class[uml-name=$nameClass]"
					mode="csvReferenceFrom" />
			</xsl:if>
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass"><!-- on ajoute tous les attributs -->
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:value-of select="concat(../uml-name,./@name-capitalized,'.ID#')" />
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** ReferenceTo *** -->
		<xsl:text>
Reference to#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/association/field">
			<xsl:if
				test="../@type='many-to-one' or (../@type='one-to-one' and ../@relation-owner='true'  and ../@transient='false')">
				<xsl:variable name="nameClass" select="../@type-short-name" />
				<xsl:apply-templates select="/diagram/classes/class[uml-name=$nameClass]"
					mode="csvReferenceTo" />
			</xsl:if>
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:if test="$isNotExpandableAttributeClass">
			<!-- on cree une seule colonne de lien vers un autre onglet -->
			<xsl:for-each
				select="/diagram/classes/class[table-name=$nameTable]/attribute[@kind='composite' and properties/property[count(field)>0]]">
				<xsl:value-of select="concat(../uml-name,./@name-capitalized,'.ID#')" />
			</xsl:for-each>
		</xsl:if>
		<!-- on ajoute tous les attributs -->
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Ctrl : NON GERE *** -->
		<xsl:text>
Ctrl#</xsl:text>

		<!-- *** Req *** -->
		<xsl:text>
Req#0##</xsl:text>
		<xsl:value-of select="$nameTable" />
		<xsl:text>#</xsl:text>

	</xsl:template>

	<!-- **************************************************** -->
	<!-- *** csvGeneratorClass : DIAGRAM/CLASS join-class *** -->
	<!-- **************************************************** -->
	<xsl:template name="csvGeneratorJoinClass">
		<xsl:param name="nameTable" />
		<xsl:param name="cptTable" />

		<!-- Variable : Name Class -->
		<xsl:variable name="uml-name"
			select="/diagram/classes/class[table-name=$nameTable]/uml-name" />

		<xsl:call-template name="csvGeneratorClassHeader">
			<xsl:with-param name="uml-name" select="$uml-name" />
			<xsl:with-param name="cptTable" select="$cptTable" />
			<xsl:with-param name="nameTable" select="$nameTable" />
		</xsl:call-template>

		<!-- *** Name *** -->
		<xsl:text>
Name#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Module *** -->
		<xsl:text>
Module#</xsl:text>

		<!-- *** Label *** -->
		<xsl:text>
Label(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>

		<!-- *** Comment *** -->
		<xsl:text>
Comment(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>champ de type seq;champ de type seq#</xsl:text>
				</xsl:when>
				<xsl:when test="field/@data-type">
					<xsl:text>champ de type number;champ de type number#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<!-- *** VisualSize *** -->
		<xsl:text>
VisualSize#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>10#</xsl:text>
		</xsl:for-each>

		<!-- *** SQL Field *** -->
		<xsl:text>
SQL FIELD#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Mandatory *** -->
		<xsl:text>
Mandatory#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>yes#</xsl:text>
		</xsl:for-each>

		<!-- *** Size *** -->
		<xsl:text>
Size#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>

		<!-- *** Type *** -->
		<xsl:text>
Type#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>seq#</xsl:text>
				</xsl:when>
				<!-- <xsl:when test="field/@data-type"><xsl:text>numberid#</xsl:text></xsl:when> -->
				<xsl:otherwise>
					<xsl:text>ref1#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<!-- *** Option *** -->
		<xsl:text>
Option#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="$nameTable" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Option2 *** -->
		<xsl:text>
Option2#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		
		<!-- *** Unique *** -->
		<xsl:text>
Unique#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>no#</xsl:text>
		</xsl:for-each>

		<!-- *** I18N : NON GERE *** -->
		<xsl:text>
I18n#</xsl:text>

		<!-- *** ReferenceFrom *** -->
		<xsl:text>
Reference from#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<!-- <xsl:variable name="nameClass" select="../@type-short-name"/> <xsl:apply-templates 
				select="/diagram/classes/class[uml-name=$nameClass]" mode="csvReferenceFrom"/> -->
			<xsl:variable name="attr-name" select="@name" />
			<xsl:variable name="class-name">
				<xsl:value-of
					select="../../left-association[attr[@name=$attr-name]]/name-for-join-class" />
				<xsl:value-of
					select="../../right-association[attr[@name=$attr-name]]/name-for-join-class" />
			</xsl:variable>
			<xsl:apply-templates
				select="/diagram/classes/class[translate(uml-name,$majuscules,$minuscules)=$class-name]"
				mode="csvReferenceFrom" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** ReferenceTo *** -->
		<xsl:text>
Reference to#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<!-- <xsl:variable name="nameClass" select="../@type-short-name"/> <xsl:apply-templates 
				select="/diagram/classes/classes/class[uml-name=$nameClass]" mode="csvReferenceTo"/> -->
			<xsl:variable name="attr-name" select="@name" />
			<xsl:variable name="class-name">
				<xsl:value-of
					select="../../left-association[attr[@name=$attr-name]]/name-for-join-class" />
				<xsl:value-of
					select="../../right-association[attr[@name=$attr-name]]/name-for-join-class" />
			</xsl:variable>
			<xsl:apply-templates
				select="/diagram/classes/class[translate(uml-name,$majuscules,$minuscules)=$class-name]"
				mode="csvReferenceTo" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>

		<!-- *** Ctrl : NON GERE *** -->
		<xsl:text>
Ctrl#</xsl:text>

		<!-- *** Req *** -->
		<xsl:text>
Req#0##</xsl:text>
		<xsl:value-of select="$nameTable" />
		<xsl:text>#</xsl:text>

	</xsl:template>

	<xsl:template name="csvGeneratorCompositeClass">
		<xsl:param name="nameTable" />
		<xsl:param name="cptTable" />
		<xsl:param name="compositeAttribute" />

		<xsl:variable name="classname"
			select="/diagram/classes/class[table-name=$nameTable]/uml-name" />

		<xsl:variable name="uml-name"
			select="concat($classname,$compositeAttribute/@name-capitalized)" />
		<xsl:variable name="relation-inverse"
			select="concat($compositeAttribute/@name-capitalized,$classname)" />
		<xsl:call-template name="csvGeneratorClassHeader">
			<xsl:with-param name="uml-name" select="$uml-name" />
			<xsl:with-param name="cptTable" select="$cptTable" />
		</xsl:call-template>

		<!-- *** Name *** -->
		<xsl:text>
Name#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:value-of select="translate($relation-inverse,$minuscules,$majuscules)" />
		<xsl:text>#</xsl:text>
		<!-- *** Module *** -->
		<xsl:text>
Module#</xsl:text>

		<!-- *** Label *** -->
		<xsl:text>
Label(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:apply-templates select="."
				mode="changeIdToIdentifier" />
		</xsl:for-each>
		<xsl:value-of
			select="translate($relation-inverse, $majuscules, $minuscules )" />
		<xsl:text>#</xsl:text>

		<!-- *** Comment *** -->
		<xsl:text>
Comment(fr_FR;en_EN)#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>champ de type seq;champ de type seq#</xsl:text>
				</xsl:when>
				<xsl:when test="field/@data-type">
					<xsl:text>champ de type number;champ de type number#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:apply-templates select="." mode="csvComment" />
		</xsl:for-each>
		<xsl:text>champ de type number;champ de type number#</xsl:text>

		<!-- *** VisualSize *** -->
		<xsl:text>
VisualSize#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>10#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:apply-templates select="." mode="csvVisualSize" />
		</xsl:for-each>
		<xsl:text>20#</xsl:text>

		<!-- *** SQL Field *** -->
		<xsl:text>
SQL FIELD#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property/field">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:text>#</xsl:text>

		<!-- *** Mandatory *** -->
		<xsl:text>
Mandatory#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>yes#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvMandatory" />
		</xsl:for-each>
		<xsl:text>yes#</xsl:text>

		<!-- *** Size *** -->
		<xsl:text>
Size#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvSize" />
		</xsl:for-each>
		<xsl:text>20#</xsl:text>

		<!-- *** Type *** -->
		<xsl:text>
Type#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:choose>
				<xsl:when test="field/sequence">
					<xsl:text>seq#</xsl:text>
				</xsl:when>
				<xsl:when test="field/@data-type">
					<xsl:text>numberid#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvType" />
		</xsl:for-each>
		<xsl:text>ref1#</xsl:text>

		<!-- *** Option *** -->
		<xsl:text>
Option#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:value-of select="$nameTable" />
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvOption" />
		</xsl:for-each>
		<xsl:text>#</xsl:text>

		<!-- *** Option2 *** -->
		<xsl:text>
Option2#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:text>#</xsl:text>

		<!-- *** Unique *** -->
		<xsl:text>
Unique#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>yes#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property">
			<xsl:apply-templates select="." mode="csvUnique" />
		</xsl:for-each>
		<xsl:text>yes#</xsl:text>

		<!-- *** I18N : NON GERE *** -->
		<xsl:text>
I18n#</xsl:text>

		<!-- *** ReferenceFrom *** -->
		<xsl:text>
Reference from#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:apply-templates select="/diagram/classes/class[table-name=$nameTable]"
			mode="csvReferenceFrom" />
		<xsl:text>#</xsl:text>

		<!-- *** ReferenceTo *** -->
		<xsl:text>
Reference to#</xsl:text>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/identifier/attribute[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:for-each
			select="/diagram/classes/class[table-name=$nameTable]/attribute/properties/property[count(field)>0]">
			<xsl:text>#</xsl:text>
		</xsl:for-each>
		<xsl:apply-templates select="/diagram/classes/class[table-name=$nameTable]"
			mode="csvReferenceTo" />
		<xsl:text>#</xsl:text>

		<!-- *** Ctrl : NON GERE *** -->
		<xsl:text>
Ctrl#</xsl:text>

		<!-- *** Req *** permet de faire un update -->
		<xsl:text>
Req#U##</xsl:text>
		<xsl:value-of select="$nameTable" />
		<xsl:text>#</xsl:text>

	</xsl:template>

	<!-- ####################################################################################################################### -->

	<!-- *********************** -->
	<!-- *** Template Entity *** -->
	<!-- *********************** <xsl:template match="class" mode="csvEntity"> 
		<xsl:text> Entity#</xsl:text> <xsl:value-of select="uml-name"/><xsl:text>#</xsl:text> 
		</xsl:template> -->

	<xsl:template match="field|attribute|property" mode="csvUnique">
		<xsl:choose>
			<xsl:when test="@unique='true'">
				<xsl:text>yes#</xsl:text>
			</xsl:when>
			<xsl:when test="@unique='false'">
				<xsl:text>no#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="csvOption">
		<xsl:choose>
			<xsl:when test="@type-short-name='boolean'">
				<xsl:text>yes[1];no[0];#</xsl:text>
			</xsl:when>
			<xsl:when test="@type-short-name='ref1'">
				<xsl:text>string#</xsl:text>
			</xsl:when>
			<xsl:when test="@enum='true'">
				<xsl:if test="@nullable='true'"><xsl:text>FWK_NONE[0];</xsl:text></xsl:if>
				<xsl:for-each select="enumeration-values/enum-value">
					<xsl:value-of select="." />
					<xsl:text>[</xsl:text>
					<xsl:value-of select="@pos" />
					<xsl:text>];</xsl:text>
				</xsl:for-each>
				<xsl:text>#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- *** Template Option - Type *** -->
	<xsl:template match="class" mode="csvOptionType">
		<xsl:choose>
			<xsl:when test="count(attribute[@name-uppercase='CODE'])=1 ">
				<xsl:apply-templates select="attribute[@name-uppercase='CODE']"
					mode="csvType" />
			</xsl:when>
			<xsl:when test="count(identifier/attribute) = 1">
				<xsl:apply-templates select="identifier/attribute"
					mode="csvType" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property|association"
		mode="csvMandatory">
		<xsl:choose>
			<xsl:when test="@nullable='true'">
				<xsl:text>no#</xsl:text>
			</xsl:when>
			<xsl:when test="@optional='true'">
				<xsl:text>no#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>yes#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="csvComment">
		<xsl:variable name="smallTypeShortName"
			select="translate(@type-short-name,$majuscules,$minuscules)" />
		<xsl:choose>
			<xsl:when test="$smallTypeShortName='mfsignature'">
				<xsl:text>champ de type string;champ de type string#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='string'">
				<xsl:text>champ de type string;champ de type string#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='long'">
				<xsl:text>champ de type number;champ de type number#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='timestamp'">
				<xsl:text>champ de type datetime;champ de type datetime#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='int' or $smallTypeShortName='integer'">
				<xsl:text>champ de type number;champ de type number#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='email'">
				<xsl:text>champ de type email;champ de type email#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='phone'">
				<xsl:text>champ de type phone;champ de type phone#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='url'">
				<xsl:text>champ de type url;champ de type url#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='boolean'">
				<xsl:text>champ de type boolean ( yes , no );champ de type boolean ( yes , no )#</xsl:text>
			</xsl:when>
			<xsl:when
				test="$smallTypeShortName='float' or $smallTypeShortName='double'">
				<xsl:text>champ de type float;champ de type float#</xsl:text>
			</xsl:when>
			<xsl:when test="@enum='true'">
				<xsl:text>champ de type enum ( </xsl:text>
				<xsl:if test="@nullable='true'"><xsl:text>FWK_NONE </xsl:text></xsl:if>
				<xsl:for-each select="enumeration-values/enum-value">
					<xsl:value-of select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:text>) ;champ de type enum ( </xsl:text>
				<xsl:if test="@nullable='true'"><xsl:text>FWK_NONE </xsl:text></xsl:if>
				<xsl:for-each select="enumeration-values/enum-value">
					<xsl:value-of select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:text>) #</xsl:text>
			</xsl:when>
			<xsl:when test="@type-short-name">
				<xsl:value-of select="@type-short-name" />
				<xsl:text>#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="csvSize">
		<xsl:variable name="smallTypeShortName"
			select="translate(@type-short-name,$majuscules,$minuscules)" />
		<xsl:choose>
			<xsl:when test="$smallTypeShortName='mfsignature'">
				<xsl:text>255#</xsl:text>
			</xsl:when>
			<xsl:when test="@length and number(@length) > 0">
				<xsl:value-of select="@length" />
				<xsl:text>#</xsl:text>
			</xsl:when>
			<xsl:when test="@precision">
				<xsl:value-of select="@precision" />
				<xsl:text>#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="csvVisualSize">
		<xsl:variable name="smallTypeShortName"
			select="translate(@type-short-name,$majuscules,$minuscules)" />
		<xsl:choose>
			<xsl:when test="$smallTypeShortName='string' and @length = '255'">
				<xsl:text>30#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='string' and @length != 255">
				<xsl:text>40#</xsl:text>
			</xsl:when>
			<xsl:when
				test="$smallTypeShortName='long' or $smallTypeShortName='int' or $smallTypeShortName='integer' or $smallTypeShortName='boolean' or $smallTypeShortName='float' or $smallTypeShortName='double'">
				<xsl:text>15#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>30#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="csvType">
		<xsl:variable name="smallTypeShortName"
			select="translate(@type-short-name,$majuscules,$minuscules)" />
		<xsl:choose>
			<xsl:when test="$smallTypeShortName='mfsignature'">
				<xsl:text>string#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='string'">
				<xsl:text>string#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='long'">
				<xsl:text>number#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='timestamp'">
				<xsl:text>datetime#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='int' or $smallTypeShortName='integer'">
				<xsl:text>number#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='email'">
				<xsl:text>email#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='phone'">
				<xsl:text>phone#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='url'">
				<xsl:text>url#</xsl:text>
			</xsl:when>
			<xsl:when test="$smallTypeShortName='boolean'">
				<xsl:text>value#</xsl:text>
			</xsl:when>
			<xsl:when
				test="$smallTypeShortName='float' or $smallTypeShortName='double'">
				<xsl:text>float#</xsl:text>
			</xsl:when>
			<xsl:when test="@enum='true'">
				<xsl:text>value#</xsl:text>
			</xsl:when>
			<xsl:when test="@type-short-name">
				<xsl:value-of select="@type-short-name" />
				<xsl:text>#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ******************************************** -->
	<!-- *** Template ReferenceFrom - Entity.Name *** -->
	<!-- ******************************************** -->
	<xsl:template match="class" mode="csvReferenceFrom">

		<xsl:choose>
			<xsl:when test="count(attribute[@name-uppercase='CODE']) = 1">
				<xsl:value-of select="uml-name" />
				<xsl:text>.CODE</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="count(identifier/attribute)=1">
					<xsl:value-of select="uml-name" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="identifier/attribute/@name-uppercase" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ****************************************** -->
	<!-- *** Template ReferenceTo - Entity.Name *** -->
	<!-- ****************************************** -->
	<xsl:template match="class" mode="csvReferenceTo">
		<xsl:if test="count(identifier/attribute)=1">
			<xsl:value-of select="uml-name" />
			<xsl:text>.</xsl:text>
			<xsl:value-of select="identifier/attribute/@name-uppercase" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="field|attribute|property" mode="changeIdToIdentifier">
		<xsl:choose>
			<xsl:when test="translate(@name,$minuscules,$majuscules)='ID'">
				<xsl:text>identifier;identifier#</xsl:text>
			</xsl:when>
			<xsl:when test="name(.)='field'">
				<xsl:value-of select="translate(../@name,$majuscules,$minuscules)" />
				<xsl:text>identifier;</xsl:text>
				<xsl:value-of select="translate(../@name,$majuscules,$minuscules)" />
				<xsl:text>identifier#</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(@name,$majuscules,$minuscules)" />
				<xsl:text>;</xsl:text>
				<xsl:value-of select="translate(@name,$majuscules,$minuscules)" />
				<xsl:text>#</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
<!-- ####################################################################################################################### -->
