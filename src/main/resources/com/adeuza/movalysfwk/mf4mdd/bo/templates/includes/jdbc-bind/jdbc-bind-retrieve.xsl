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

<xsl:template name="jdbc-retrieve">
	<xsl:param name="interface"/>
	<xsl:param name="optimList"/>
	<xsl:param name="resultSet"/>
	<xsl:param name="traitementFill">false</xsl:param>
	<xsl:param name="object">r_o<xsl:value-of select="$interface/name"/></xsl:param>

	<xsl:if test="parent::class or parent::identifier">
		<xsl:value-of select="$object"/>.<xsl:value-of select="set-accessor"/>
			<xsl:text>(</xsl:text>
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text">
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text"><xsl:value-of select="jdbc-retrieve"/></xsl:with-param>
						<xsl:with-param name="from">POSITION</xsl:with-param>
						<xsl:with-param name="to"><xsl:value-of select="@pos"/></xsl:with-param>						
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="from">RESULTSET</xsl:with-param>
				<xsl:with-param name="to" select="$resultSet"/>
			</xsl:call-template><xsl:text>);
		</xsl:text>	
	</xsl:if>
		
	<!-- Si traitement get ou ( traitement fill mais la relation n'est pas Loadable ) -->
	<xsl:if test="$traitementFill = 'false' or count(ancestor::association/interface/linked-interfaces/linked-interface[ name = 'MethodLoadable']) = 0">
		<xsl:call-template name="jdbc-getretrieve-relation-to-one">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="optimList" select="$optimList"/>
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="resultSet" select="$resultSet"/>
		</xsl:call-template>
	</xsl:if>
	
	<!-- Si traitement Fill et la relation est Loadable -->
	<xsl:if test="$traitementFill = 'true' and count(ancestor::association/interface/linked-interfaces/linked-interface[ name = 'MethodLoadable']) > 0">
		<xsl:call-template name="jdbc-fillretrieve-relation-to-one">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="optimList" select="$optimList"/>
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="resultSet" select="$resultSet"/>
		</xsl:call-template>
	</xsl:if>
		
</xsl:template>


<xsl:template name="jdbc-retrieve-key">
	<xsl:param name="interface"/>
	<xsl:param name="prefix"/>
	<xsl:param name="resultSet"/>
	
	<xsl:value-of select="$prefix"/><xsl:value-of select="$interface/name"/>.<xsl:value-of select="../../set-accessor"/>
		<xsl:text>(</xsl:text>
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text">
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text"><xsl:value-of select="../../jdbc-retrieve"/></xsl:with-param>
					<xsl:with-param name="from">POSITION</xsl:with-param>
					<xsl:with-param name="to"><xsl:value-of select="../../@pos"/></xsl:with-param>
					<!-- xsl:with-param name="to"><xsl:value-of select="$interface/name"/>Field.<xsl:value-of select="../@cascade-name"/><xsl:value-of select="../@name"/>.name()</xsl:with-param-->
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="from">RESULTSET</xsl:with-param>
			<xsl:with-param name="to"><xsl:value-of select="$resultSet"/></xsl:with-param>									
		</xsl:call-template><xsl:text>);</xsl:text>	
</xsl:template>

<!-- 
 Lors de la lecture d'une association dans le resultset, récupére la version en cache.
 Méthode différente en fonction de s'il s'agit d'une MethodLoadable ou pas
 -->
<xsl:template name="jdbc-retrieve-readassociation-fromcache">

	<xsl:variable name="associationNameWithUpper"><xsl:text>o</xsl:text><xsl:call-template name="first-letter-to-uppercase"><xsl:with-param name="text"><xsl:value-of select="../@name"/></xsl:with-param></xsl:call-template></xsl:variable>

	<xsl:value-of select="../interface/name"/><xsl:text> oCached</xsl:text><xsl:value-of select="../@name"/>
	<xsl:text> = (</xsl:text><xsl:value-of select="../interface/name"/>
	<xsl:text>) p_oDaoSession.getFromCache(</xsl:text>
	<xsl:value-of select="../interface/name"/>
	<xsl:text>.ENTITY_NAME, </xsl:text>

	<xsl:if test="count(../interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) = 0 ">
 		<xsl:value-of select="$associationNameWithUpper"/><xsl:text>.idToString()</xsl:text>
	</xsl:if>
	
	<xsl:if test="count(../interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0 ">
		<xsl:text> LoadMethod</xsl:text><xsl:value-of select="../interface/name"/>
		<xsl:text>.BY_ID.getHelper().getCacheKeyOfEntity(</xsl:text><xsl:value-of select="$associationNameWithUpper"/>
		<xsl:text>)</xsl:text>
	</xsl:if>
	
	<xsl:text>);</xsl:text>
	
</xsl:template>

</xsl:stylesheet>