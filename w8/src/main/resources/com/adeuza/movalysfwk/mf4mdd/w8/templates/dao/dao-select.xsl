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

<xsl:include href="dao/select/dao-getbypk.xsl"/>
<xsl:include href="dao/select/dao-getlist.xsl"/>
<xsl:include href="dao/select/dao-getnb.xsl"/>

<xsl:template match="dao-interface" mode="dao-select-region">
	
	<xsl:text>#region SELECT&#13;&#13;</xsl:text>
	
	<xsl:apply-templates select="." mode="get-by-pk"/>
	<xsl:apply-templates select="." mode="get-list"/>
	
	<!--
	Le framework n'implémente pas de méthode permettant de récupérer la liste des identifiants d'une table 
	<xsl:apply-templates select="." mode="get-list-id"/>
	 -->
	
	<xsl:apply-templates select="." mode="get-nb"/>	
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>
	
</xsl:template>

<xsl:template match="dao" mode="dao-select-region">
	
	<xsl:text>#region SELECT&#13;&#13;</xsl:text>
	
	<xsl:apply-templates select="." mode="get-by-pk"/>
	<xsl:apply-templates select="." mode="get-list"/>
	
	<!--
	Le framework n'implémente pas de méthode permettant de récupérer la liste des identifiants d'une table 
	<xsl:apply-templates select="." mode="get-list-id"/>
	 -->
	
	<xsl:apply-templates select="." mode="get-nb"/>	
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>
	
</xsl:template>

</xsl:stylesheet>