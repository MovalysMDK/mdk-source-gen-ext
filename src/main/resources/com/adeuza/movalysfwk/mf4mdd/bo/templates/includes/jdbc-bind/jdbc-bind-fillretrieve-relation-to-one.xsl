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

<!--
Traitement des relations vers 1 dans le cas des méthodes fill 
-->
<xsl:template name="jdbc-fillretrieve-relation-to-one">
	<xsl:param name="interface"/>
	<xsl:param name="optimList"/>
	<xsl:param name="object">r_o<xsl:value-of select="$interface/name"/></xsl:param>
	<xsl:param name="resultSet"/>
	

	<xsl:if test="count(ancestor::association) = 1 and ancestor::association/@type !='one-to-many'">
	
	if ( <xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>() != null ) {
		<xsl:value-of select="../interface/name"/> oCached<xsl:value-of select="../interface/name"/>
				<xsl:text> = (</xsl:text><xsl:value-of select="../interface/name"/>
				<xsl:text>) p_oDaoSession.getFromCache( </xsl:text>
				<xsl:value-of select="../interface/name"/><xsl:text>.ENTITY_NAME, </xsl:text> 
				<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>
				<xsl:text>().getLoadMethod().getHelper().getCacheKeyOfEntity(</xsl:text>
				<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>()));
		if (oCached<xsl:value-of select="../interface/name"/> != null) {
			<xsl:value-of select="$object"/>.<xsl:value-of select="../set-accessor"/>(oCached<xsl:value-of select="../interface/name"/>);
		}
		else {
			if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>.Cascade.<xsl:value-of select="../@cascade-name"/>)) {
				p_oCascadeOptim.registerEntityForCascadeUsingLoadMethod(<xsl:value-of select="$interface/name"/>
					<xsl:text>.Cascade.</xsl:text><xsl:value-of select="../@cascade-name"/>, 
					<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>());
			}
		}
	}
	else {
		<!-- cas classique -->
		<xsl:call-template name="jdbc-getretrieve-relation-to-one">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="optimList" select="'true'"/>
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="resultSet" select="$resultSet"/>
		</xsl:call-template>
	}
	
	</xsl:if>
	
</xsl:template>

</xsl:stylesheet>