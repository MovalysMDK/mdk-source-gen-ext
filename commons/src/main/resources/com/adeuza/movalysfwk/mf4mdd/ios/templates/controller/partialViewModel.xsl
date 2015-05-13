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


<xsl:template match="controller" mode="partialViewModel-methods">
	<xsl:apply-templates select="." mode="usePartialViewModel-method"/>
	<xsl:apply-templates select="." mode="partialViewModelKeys-method"/>
</xsl:template>	


<!-- usePartialViewModel method -->
<xsl:template match="controller[(@controllerType='FORMVIEW' and ./workspaceRole = 'WORKSPACE_DETAIL')]" mode="usePartialViewModel-method">
-(BOOL) usePartialViewModel {
	return YES;
}
</xsl:template>	

<!-- usePartialViewModel method -->
<xsl:template match="controller[(@controllerType='FORMVIEW' and ./workspaceRole = 'WORKSPACE_DETAIL')]" mode="partialViewModelKeys-method">
-(NSArray *) partialViewModelKeys {
	return @[<xsl:apply-templates select="./sections" mode="viewModelAttributeNames"/>];
}
</xsl:template>	


<xsl:template match="sections" mode="viewModelAttributeNames">
	<xsl:for-each select="section">
		@"<xsl:value-of select="viewModelAttributeInParent"/>"<xsl:if test="position() != last()"><xsl:text>,&#13;</xsl:text></xsl:if>
	</xsl:for-each>
</xsl:template>	

<xsl:template match="*" priority="-1000" mode="usePartialViewModel-method">
</xsl:template>	

<xsl:template match="*" priority="-1000" mode="partialViewModelKeys-method">
</xsl:template>	


</xsl:stylesheet>