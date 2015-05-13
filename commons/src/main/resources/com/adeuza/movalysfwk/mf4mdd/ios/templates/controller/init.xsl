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

<!-- init methods (default) -->
<xsl:template match="controller" mode="init-methods">

#pragma mark - initialize

-(void) initialize {
    [super initialize];
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">initialize</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="initialize-body"/>
		</xsl:with-param>
	</xsl:call-template>
}

</xsl:template>

<xsl:template match="controller[@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D']" mode="initialize-body">
	
	<xsl:text>self.itemIdentifier = @"</xsl:text>
	<xsl:value-of select="itemIdentifier"/>
	<xsl:text>";&#13;</xsl:text>
		
	<xsl:if test="detailStoryboard">
		<xsl:text>self.detailStoryboardName = @"</xsl:text>
		<xsl:value-of select="detailStoryboard/name"/>
		<xsl:text>";&#13;</xsl:text>
	</xsl:if>
	<xsl:if test="newItemButton = 'true'">
		<xsl:text>self.showAddItemButton = YES;&#13;</xsl:text>
	</xsl:if>
	<xsl:if test="deleteAction">
		<xsl:text>self.deleteAction = MFAction_</xsl:text>
		<xsl:value-of select="deleteAction"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:if>
	<xsl:if test="workspaceRole = 'WORKSPACE_MASTER' and @controllerType='LISTVIEW'">
		<xsl:text>self.longPressToDelete = YES;&#13;</xsl:text>
	</xsl:if>

</xsl:template>

<xsl:template match="controller" mode="initialize-body">
</xsl:template>


</xsl:stylesheet>