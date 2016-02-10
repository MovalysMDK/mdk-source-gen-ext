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
<xsl:output method="text" encoding="utf-8"/>
	
<xsl:variable name="majuscules">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ</xsl:variable>
<xsl:variable name="minuscules">abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ</xsl:variable>


<!-- ****************************** -->
<!-- *** csvGenerator : DIAGRAM *** -->
<!-- ****************************** -->
<xsl:template match="diagram">
	<xsl:apply-templates select="classes/class[transient='false']" mode="csvGeneratorTable"/>
</xsl:template>

<!-- ************************************************ -->
<!-- *** csvGeneratorTable : DIAGRAM/SCHEMA/TABLE *** -->
<!-- ************************************************ -->
<xsl:template match="class" mode="csvGeneratorTable">
	<xsl:if test="not(@join-class) or @join-class='false'">
	    <xsl:apply-templates mode="csvGeneratorClass" select=".">
		    <xsl:with-param name="nameTable" select="concat('T_',uml-name)"/>
		    <xsl:with-param name="cptTable" select="format-number((position()*10), '000')"/>
	    </xsl:apply-templates>
	</xsl:if>
	
	<xsl:if test="@join-class='true'">
	    <xsl:apply-templates mode="csvGeneratorJoinClass" select=".">
		    <xsl:with-param name="nameTable" select="uml-name"/>
		    <xsl:with-param name="cptTable" select="format-number((position()*10), '000')"/>
	    </xsl:apply-templates>
	</xsl:if>
	
</xsl:template>


<!-- ************************************************* -->
<!-- *** csvGeneratorClass : DIAGRAM/CLASSES/CLASS *** -->
<!-- ************************************************* -->	
<xsl:template mode="csvGeneratorClass" match="class">
	 <xsl:param name="nameTable"/>
	 <xsl:param name="cptTable"/>

<!-- Variable : Name Class -->
<xsl:variable name="uml-name" select="uml-name"/>

<!-- *** Entity *** -->
<xsl:text>
Entity#</xsl:text>
<xsl:value-of select="$uml-name"/>

<!-- *** Group *** -->
<xsl:text>
Group#generated_model</xsl:text>

<!-- *** Products *** -->
<xsl:text>
Products#NAME_PRODUCT</xsl:text>

<!-- *** FileName *** -->
<xsl:text>
FileName#User</xsl:text><xsl:value-of select="$cptTable"/><xsl:text>_</xsl:text><xsl:value-of select="$uml-name"/>
	
<!-- *** Admable *** -->
<xsl:text>
Admable#No</xsl:text>

<!-- *** Title *** -->
<xsl:text>
Title(fr_FR;en_EN)#</xsl:text>
<xsl:value-of select="$uml-name"/><xsl:text>;</xsl:text><xsl:value-of select="$uml-name"/>

<!-- *** Tab Title *** -->
<xsl:text>
TabTitle(fr_FR;en_EN)#</xsl:text>
<xsl:value-of select="$uml-name"/><xsl:text>;</xsl:text><xsl:value-of select="$uml-name"/>

<!-- *** Name *** -->
<xsl:text>
Name#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="count(attribute)>0">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:value-of select="translate(attribute/@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/>
			<xsl:variable name="nameClass" select="@type-short-name"/>
			<xsl:variable name="nameIdentifier"><xsl:apply-templates select="/diagram/classes/class[name=$nameClass]" mode="csvFieldIdentifierName"/></xsl:variable>
			<xsl:value-of select="translate($nameIdentifier,$minuscules,$majuscules)"/>
			<xsl:text>#</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>

<!-- *** Module *** -->
<xsl:text>
Module#</xsl:text>

<!-- *** Label *** -->
<xsl:text>
Label(fr_FR;en_EN)#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="@name"/><xsl:text>;</xsl:text>
	<xsl:value-of select="@name"/><xsl:text>#</xsl:text>
</xsl:for-each>

<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="count(attribute)>0">
			<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/><xsl:value-of select="translate(attribute/@name,$majuscules,$minuscules)"/><xsl:text>;</xsl:text>
			<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/><xsl:value-of select="translate(attribute/@name,$majuscules,$minuscules)"/><xsl:text>#</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/>
			<xsl:text>#</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<xsl:for-each select="./attribute[@transient='false']">
	<xsl:value-of select="@name"/><xsl:text>;</xsl:text>
	<xsl:value-of select="@name"/><xsl:text>#</xsl:text>
</xsl:for-each>

<!-- *** Comment *** -->
<xsl:text>
Comment(fr_FR;en_EN)#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="coredata-type"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="./attribute/coredata-type"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when>
		<xsl:when test="count(./attribute) = 0"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when> 
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="coredata-type='Boolean'"><xsl:text>yes[1]no[0]#</xsl:text></xsl:when>
		<xsl:when test="@enum='true'"><xsl:text>champ de type enum </xsl:text>
			<xsl:text>FWK_NONE[0] </xsl:text>
			<xsl:for-each select="enumeration-values/enum-value">
				<xsl:value-of select="."/><xsl:text>[</xsl:text><xsl:value-of select="@pos"/><xsl:text>] </xsl:text>
			</xsl:for-each>
			<xsl:text>;champ de type enum </xsl:text>
			<xsl:text>FWK_NONE[0] </xsl:text>
			<xsl:for-each select="enumeration-values/enum-value">
				<xsl:value-of select="."/><xsl:text>[</xsl:text><xsl:value-of select="@pos"/><xsl:text>] </xsl:text>
			</xsl:for-each>
			<xsl:text>#</xsl:text>
		</xsl:when>
		<!-- <xsl:when test="@enum='true'"><xsl:text>champ de type enum;champ de type enum#</xsl:text></xsl:when> -->
		<xsl:when test="coredata-type ='String'"><xsl:text>champ de type string;champ de type string#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Integer 16'"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Integer 32'"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Date'"><xsl:text>champ de type datetime;champ de type datetime#</xsl:text></xsl:when>
		<!-- 
		<xsl:when test="coredata-type='email'"><xsl:text>champ de type email;champ de type email#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='phone'"><xsl:text>champ de type phone;champ de type phone#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='url'"><xsl:text>champ de type url;champ de type url#</xsl:text></xsl:when>
		 -->
		<xsl:when test="coredata-type='Boolean'"><xsl:text>champ de type boolean yes[1] no[0];champ de type boolean yes[1] no[0]#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Float' or coredata-type='Double'"><xsl:text>champ de type float;champ de type float#</xsl:text></xsl:when>
		<xsl:when test="coredata-type"><xsl:value-of select="coredata-type"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** VisualSize *** -->
<xsl:text>
VisualSize#</xsl:text>
<xsl:for-each select="./identifier/attribute"><xsl:text>10#</xsl:text></xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']"><xsl:text>20#</xsl:text></xsl:for-each>
<xsl:for-each select="./attribute">
	<xsl:choose>
		<xsl:when test="coredata-type='String' and @length = '255'"><xsl:text>30#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='String' and @length != 255"><xsl:text>40#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Integer 32' or coredata-type='Integer 16' or coredata-type='Boolean' or coredata-type='Float' or coredata-type='Double'"><xsl:text>15#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>30#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** SQL Field *** -->
<xsl:text>
SQL FIELD#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="count(attribute) > 0 and @relation-owner='true'">
			<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:value-of select="translate(attribute/@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>#</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<xsl:for-each select="./attribute[@transient='false']">
	<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>

<!-- *** Mandatory *** -->
<xsl:text>
Mandatory#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>yes#</xsl:text>
</xsl:for-each>

<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="@optional='true'"><xsl:text>no#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>yes#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="@nullable='true'"><xsl:text>no#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>yes#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** Size *** -->
<xsl:text>
Size#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="@length"><xsl:value-of select="@length"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:when test="@precision"><xsl:value-of select="@precision"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>20#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="@length"><xsl:value-of select="@length"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:when test="@precision"><xsl:value-of select="@precision"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>20#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="@length"><xsl:value-of select="@length"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:when test="@precision"><xsl:value-of select="@precision"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>255#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** Type *** -->
<xsl:text>
Type#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="@type-name"><xsl:text>numberid#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./association[(@type='many-to-one' or @type='one-to-one') and @transient='false']">
	<xsl:choose>
		<xsl:when test="@type='many-to-one' or (@type='one-to-one' and @transient='false')"><xsl:text>ref1#</xsl:text></xsl:when>
		<xsl:when test="coredata-type"><xsl:text>number#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="@enum='true'"><xsl:text>value#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='String'"><xsl:text>string#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Integer 16'"><xsl:text>number#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Date'"><xsl:text>datetime#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Integer 32'"><xsl:text>number#</xsl:text></xsl:when><!-- 
		<xsl:when test="coredata-type='email'"><xsl:text>email#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='phone'"><xsl:text>phone#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='url'"><xsl:text>url#</xsl:text></xsl:when> -->
		<xsl:when test="coredata-type='Boolean'"><xsl:text>value#</xsl:text></xsl:when>
		<xsl:when test="coredata-type='Float' or coredata-type='Double'"><xsl:text>float#</xsl:text></xsl:when>
		<xsl:when test="coredata-type"><xsl:value-of select="coredata-type"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** Option *** -->
<xsl:text>
Option#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="$nameTable"/><xsl:text>#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association">
	<xsl:if test="(@type='many-to-one' or @type='one-to-one')  and @transient='false'">
		<xsl:variable name="nameClass" select="@type-short-name"/>
		<xsl:apply-templates select="/diagram/classes/class[name=$nameClass]" mode="csvOptionType"/>
	</xsl:if>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="coredata-type='Boolean'"><xsl:text>yes[1];no[0]#</xsl:text></xsl:when>
		<xsl:when test="@enum='true'">
			<xsl:text>FWK_NONE[0];</xsl:text>
			<xsl:for-each select="enumeration-values/enum-value">
				<xsl:value-of select="."/><xsl:text>[</xsl:text><xsl:value-of select="@pos"/><xsl:text>];</xsl:text>
			</xsl:for-each>
			<xsl:text>#</xsl:text>
		</xsl:when>
		<xsl:when test="coredata-type='ref1'"><xsl:text>string#</xsl:text></xsl:when>
		
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** Option2 : NON GERE *** -->
<xsl:text>
Option2#</xsl:text>

<!-- *** Unique *** -->
<xsl:text>
Unique#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>yes#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association">
	<xsl:choose>
		<xsl:when test="count(attribute)>0">
			<xsl:if test="(@type='many-to-one' or @type='one-to-one') and @transient='false'">
				<xsl:choose>
					<xsl:when test="attribute/@unique='true'"><xsl:text>yes#</xsl:text></xsl:when>
					<xsl:when test="attribute/@unique='false'"><xsl:text>no#</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<xsl:for-each select="./attribute[@transient='false']">
	<xsl:choose>
		<xsl:when test="@unique='true'"><xsl:text>yes#</xsl:text></xsl:when>
		<xsl:when test="@unique='false'"><xsl:text>no#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>

<!-- *** I18N : NON GERE ***  -->
<xsl:text>
I18n#</xsl:text>

<!-- *** ReferenceFrom *** -->
<xsl:text>
Reference from#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association">
	<xsl:if test="(@type='many-to-one' or @type='one-to-one') and @transient='false'">
		<xsl:variable name="nameClass" select="@type-short-name"/>
		<xsl:apply-templates select="/diagram/classes/class[name=$nameClass]" mode="csvReferenceFrom"/>
		<xsl:text>#</xsl:text>
	</xsl:if>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:text>#</xsl:text>
</xsl:for-each>
<!-- *** ReferenceTo *** -->
<xsl:text>
Reference to#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>#</xsl:text>
</xsl:for-each>
<xsl:for-each select="./association">
	<xsl:if test="(@type='many-to-one' or @type='one-to-one') and @transient='false'">
		<xsl:variable name="nameClass" select="@type-short-name"/>
		<xsl:apply-templates select="/diagram/classes/class[name=$nameClass]" mode="csvReferenceTo"/>
		<xsl:text>#</xsl:text>
	</xsl:if>
</xsl:for-each>
<xsl:for-each select="./attribute[@transient='false']">
	<xsl:text>#</xsl:text>
</xsl:for-each>

<!-- *** Ctrl : NON GERE *** -->
<xsl:text>
Ctrl#</xsl:text>

<!-- *** Req *** -->
<xsl:text>
Req#0##</xsl:text><xsl:value-of select="$nameTable"/><xsl:text>#</xsl:text>
		
</xsl:template>

<!-- **************************************************** -->
<!-- *** csvGeneratorClass : DIAGRAM/CLASS join-class *** -->
<!-- **************************************************** -->	
<xsl:template mode="csvGeneratorJoinClass" match="class">
	 <xsl:param name="nameTable"/>
	 <xsl:param name="cptTable"/>

<!-- Variable : Name Class -->
<xsl:variable name="uml-name" select="./uml-name"/>

<!-- *** Entity *** -->
<xsl:text>
Entity#</xsl:text>
<xsl:value-of select="$uml-name"/>

<!-- *** Group *** -->
<xsl:text>
Group#generated_model</xsl:text>

<!-- *** Products *** -->
<xsl:text>
Products#NAME_PRODUCT</xsl:text>

<!-- *** FileName *** -->
<xsl:text>
FileName#G</xsl:text><xsl:value-of select="$cptTable"/><xsl:text>_</xsl:text>
<xsl:choose>
	<xsl:when test="./@join-class ='true'">
		<xsl:value-of select="./left-association/real-name-for-join-class"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="./right-association/name"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="./right-association/real-name-for-join-class"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="./left-association/name"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$uml-name"/>
	</xsl:otherwise>
</xsl:choose>

<!-- *** Admable *** -->
<xsl:text>
Admable#No</xsl:text>

<!-- *** Title *** -->
<xsl:text>
Title(fr_FR;en_EN)#</xsl:text>
<xsl:value-of select="$uml-name"/><xsl:text>;</xsl:text><xsl:value-of select="$uml-name"/>

<!-- *** Tab Title *** -->
<xsl:text>
TabTitle(fr_FR;en_EN)#</xsl:text>
<xsl:value-of select="$uml-name"/><xsl:text>;</xsl:text><xsl:value-of select="$uml-name"/>

<!-- *** Name *** -->
<xsl:text>
Name#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="translate(@name,$minuscules,$majuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>

<!-- *** Module *** -->
<xsl:text>
Module#</xsl:text>

<!-- *** Label *** -->
<xsl:text>
Label(fr_FR;en_EN)#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/><xsl:text>;</xsl:text>
	<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>
  
<!-- *** Comment *** -->
<xsl:text>
Comment(fr_FR;en_EN)#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="coredata-type"><xsl:text>champ de type number;champ de type number#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
  
<!-- *** VisualSize *** -->
<xsl:text>
VisualSize#</xsl:text>
<xsl:for-each select="./identifier/attribute"><xsl:text>10#</xsl:text></xsl:for-each>
  
<!-- *** SQL Field *** -->
<xsl:text>
SQL FIELD#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:value-of select="translate(@name,$majuscules,$minuscules)"/><xsl:text>#</xsl:text>
</xsl:for-each>
  
<!-- *** Mandatory *** -->
<xsl:text>
Mandatory#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>yes#</xsl:text>
</xsl:for-each>
  
<!-- *** Size *** -->
<xsl:text>
Size#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="@length"><xsl:value-of select="@length"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:when test="@precision"><xsl:value-of select="@precision"/><xsl:text>#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>20#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
  
<!-- *** Type *** -->
<xsl:text>
Type#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:choose>
		<xsl:when test="coredata-type"><xsl:text>ref1#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
  
<!-- *** Option *** -->
<xsl:text>
Option#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:variable name="attr-name" select="@name"/>
	<xsl:variable name="class-name">
		<xsl:value-of select="../../left-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
		<xsl:value-of select="../../right-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
	</xsl:variable>
	<xsl:apply-templates select="/diagram/classes/class[name=$class-name]" mode="csvOptionType"/>
</xsl:for-each>
  
<!-- *** Option2 : NON GERE *** -->
<xsl:text>
Option2#</xsl:text>

<!-- *** Unique *** -->
<xsl:text>
Unique#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:text>no#</xsl:text>
</xsl:for-each>
  
<!-- *** I18N : NON GERE *** -->
<xsl:text>
I18n#</xsl:text>

<!-- *** ReferenceFrom *** -->
<xsl:text>
Reference from#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:variable name="attr-name" select="@name"/>
	<xsl:variable name="class-name">
		<xsl:value-of select="../../left-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
		<xsl:value-of select="../../right-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
	</xsl:variable>
	<xsl:apply-templates select="/diagram/classes/class[uml-name=$class-name]" mode="csvReferenceFrom"/>
	<xsl:text>#</xsl:text>
</xsl:for-each>
  
<!-- *** ReferenceTo *** -->
<xsl:text>
Reference to#</xsl:text>
<xsl:for-each select="./identifier/attribute">
	<xsl:variable name="attr-name" select="@name"/>
	<xsl:variable name="class-name">
		<xsl:value-of select="../../left-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
		<xsl:value-of select="../../right-association[attr[@name=$attr-name]]/real-name-for-join-class"/>
	</xsl:variable>
	<xsl:apply-templates select="/diagram/classes/class[uml-name=$class-name]" mode="csvReferenceTo"/>
	<xsl:text>#</xsl:text>
</xsl:for-each>
  
<!-- *** Ctrl : NON GERE *** -->
<xsl:text>
Ctrl#</xsl:text>

<!-- *** Req *** -->
<xsl:text>
Req#0##</xsl:text><xsl:value-of select="$nameTable"/><xsl:text>#</xsl:text>
		
</xsl:template>


<!-- ####################################################################################################################### -->

<!-- *********************** -->
<!-- *** Template Entity *** -->
<!-- *********************** -->
<xsl:template match="class" mode="csvEntity">
	<xsl:text>
	Entity#</xsl:text>
	<xsl:value-of select="uml-name"/><xsl:text>#</xsl:text>
</xsl:template>

<!-- *** Template Option - Type *** -->	
<xsl:template match="class" mode="csvOptionType">
	<xsl:choose>
		<xsl:when test="count(attribute[@name-uppercase='CODE'])=1 ">
			<xsl:apply-templates select="attribute[@name-uppercase='CODE']" mode="csvType"/>
		</xsl:when>
		<xsl:when test="count(identifier/attribute) = 1">
			<xsl:apply-templates select="identifier/attribute" mode="csvType"/>
		</xsl:when>
		<!-- 
		<xsl:when test="attribute/@name-uppercase='CODE'">
			<xsl:choose>
				<xsl:when test="attribute/@enum='true'"><xsl:text>value#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='String'"><xsl:text>string#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='Integer 32'"><xsl:text>number#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='Date'"><xsl:text>datetime#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='Integer 16'"><xsl:text>number#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='email'"><xsl:text>email#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='phone'"><xsl:text>phone#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='url'"><xsl:text>url#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='Boolean'"><xsl:text>value#</xsl:text></xsl:when>
				<xsl:when test="attribute/coredata-type='Float' or attribute/coredata-type='Double'"><xsl:text>float#</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="identifier/attribute/@name-uppercase='IDENTIFIER'">
			<xsl:choose>
				<xsl:when test="identifier/attribute/@enum='true'"><xsl:text>value#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='String'"><xsl:text>string#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='Integer 32'"><xsl:text>number#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='Date'"><xsl:text>datetime#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='Integer 16'"><xsl:text>number#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='email'"><xsl:text>email#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='phone'"><xsl:text>phone#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='url'"><xsl:text>url#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='Boolean'"><xsl:text>value#</xsl:text></xsl:when>
				<xsl:when test="identifier/attribute/coredata-type='Float' or identifier/attribute/coredata-type='Double'"><xsl:text>float#</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		 -->
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="field|attribute|property" mode="csvType">
	<xsl:variable name="smallTypeShortName" select="translate(@type-short-name,$majuscules,$minuscules)"/>
	<xsl:choose>
		<xsl:when test="identifier/attribute/@enum='true'"><xsl:text>value#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='String'"><xsl:text>string#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='Integer 32'"><xsl:text>number#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='Date'"><xsl:text>datetime#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='Integer 16'"><xsl:text>number#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='email'"><xsl:text>email#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='phone'"><xsl:text>phone#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='url'"><xsl:text>url#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='Boolean'"><xsl:text>value#</xsl:text></xsl:when>
		<xsl:when test="identifier/attribute/coredata-type='Float' or identifier/attribute/coredata-type='Double'"><xsl:text>float#</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>#</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ******************************************** -->
<!-- *** Template ReferenceFrom - Entity.Name *** -->
<!-- ******************************************** -->	
<xsl:template match="class" mode="csvReferenceFrom">
	<xsl:if test="count(identifier/attribute)=1">
		<xsl:value-of select="uml-name"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="identifier/attribute/@name-uppercase"/>
	</xsl:if>
</xsl:template>

<!-- ****************************************** -->
<!-- *** Template ReferenceTo - Entity.Name *** -->
<!-- ****************************************** -->	
<xsl:template match="class" mode="csvReferenceTo">
	<xsl:if test="count(identifier/attribute)=1">
		<xsl:value-of select="uml-name"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="identifier/attribute/@name-uppercase"/>
	</xsl:if>
</xsl:template>
	
<xsl:template match="class" mode="csvFieldName">
	<xsl:if test="count(identifier/attribute)=1">
		<xsl:value-of select="uml-name"/>
		<xsl:value-of select="identifier/attribute/@name-uppercase"/>
	</xsl:if>
</xsl:template>

<xsl:template match="class" mode="csvFieldIdentifierName">
	<xsl:if test="count(identifier/attribute)=1">
		<xsl:value-of select="identifier/attribute/@name-uppercase"/>
	</xsl:if>
</xsl:template>
	

</xsl:stylesheet>

<!-- ####################################################################################################################### -->
