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
Construit le inner join à partir d'un noeud method-signature
La classe doit être passé en paramètre.
 -->
<xsl:template name="innerjoin">
	<xsl:param name="classe"/>

<xsl:for-each select="method-parameter/descendant::join-table">
	<xsl:text> INNER JOIN </xsl:text>
	
	<xsl:variable name="pos" select="position()"/>
	
	<!-- table de jointure -->
	<xsl:value-of select="name"/>
	<xsl:text>_{</xsl:text>
	<xsl:value-of select="$pos * 3 + 1 "/>
	<xsl:text>}{</xsl:text>
	<xsl:value-of select="$pos * 3 + 2 "/>
	<xsl:text>} </xsl:text>
	<!-- alias de la table de jointure -->
	<xsl:text>{</xsl:text>
	<xsl:value-of select="$pos * 3 "/>
	<xsl:text>}</xsl:text>
	
	<!--  ON -->
	<xsl:text> ON </xsl:text>
	<xsl:for-each select="key-fields/field">
		<xsl:text>{</xsl:text>
		<xsl:value-of select="$pos * 3 "/>
		<xsl:text>}.</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text> = </xsl:text>
		<xsl:text>{0}.</xsl:text>
		<xsl:variable name="position" select="position()"/>
		<xsl:value-of select="$classe/identifier/descendant::field[position() = $position]/@name"/>
		<xsl:if test="position() != last()">
			<xsl:text> AND </xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>