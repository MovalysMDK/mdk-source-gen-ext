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

<xsl:output method="text"/>	

<xsl:template match="class" mode="idtostring">	
	
	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.mf4jcommons.core.beans.MIdentifiable#idToString()
	 */
	@Override
	public String idToString() {
		StringBuilder r_sId = new StringBuilder();
		<xsl:for-each select="identifier/descendant::attribute">
			<xsl:if test="parent::identifier">
				<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
				<xsl:value-of select="@name"/><xsl:text>));
				</xsl:text>
			</xsl:if>
			<xsl:if test="parent::association">
				<xsl:text>r_sId.append( String.valueOf( this.</xsl:text><xsl:value-of select="../@name"/>
				<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()));
				</xsl:text>
			</xsl:if>
			<xsl:if test="position() != last()">
				<xsl:text>r_sId.append('|');
				</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>return r_sId.toString();</xsl:text>
	}

	<xsl:if test="@join-class = 'true'">
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="left-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="left-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	 public String <xsl:value-of select="left-association/name-for-join-class"/>IdToString() {
	 	StringBuffer r_sId = new StringBuffer();
	 	<xsl:for-each select="left-association/attr">
	 		<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
	 		<xsl:value-of select="@name"/>
	 		<xsl:text>));</xsl:text>
	 		<xsl:if test="position() != last()">
			<xsl:text>r_sId.append('|');
			</xsl:text>
			</xsl:if>
	 	</xsl:for-each>
	 	return r_sId.toString();
	 }
	 
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="right-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="right-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	 public String <xsl:value-of select="right-association/name-for-join-class"/>IdToString() {
	 	StringBuffer r_sId = new StringBuffer();
	 	<xsl:for-each select="right-association/attr">
	 		<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
	 		<xsl:value-of select="@name"/>
	 		<xsl:text>));</xsl:text>
	 		<xsl:if test="position() != last()">
			<xsl:text>r_sId.append('|');
			</xsl:text>
			</xsl:if>
	 	</xsl:for-each>
	 	return r_sId.toString();
	 }
	</xsl:if>
	
</xsl:template>
</xsl:stylesheet>
