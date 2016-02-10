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

<!-- import interface -->
<xsl:template match="controller" mode="container-interface-import">
	<xsl:choose>
		<xsl:when test="workspaceRole='WORKSPACE_DETAIL'">
			<xsl:text>#import "MFWorkspaceDetailColumnProtocol.h"&#10;</xsl:text>
		</xsl:when>
		<xsl:when test="workspaceRole='WORKSPACE_MASTER'">
			<xsl:text>#import "MFWorkspaceMasterColumnProtocol.h"&#10;</xsl:text>
		</xsl:when>
		<xsl:when test="workspaceRole='NOT_IN_WORKSPACE' and isInContainerViewController='true'">
			<xsl:text>#import "MFPanelProtocol.h"&#10;</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="isInContainerViewController='true' and count(saveActionNames/saveActionName)&gt;0">
		<xsl:text>#import "MFChildSaveProtocol.h"</xsl:text>
	</xsl:if>
</xsl:template>


<!-- import impl -->
<xsl:template match="controller[workspaceRole='WORKSPACE_DETAIL' or workspaceRole='WORKSPACE_MASTER']" mode="container-impl-import">
#import "MFWorkspaceViewController.h"
</xsl:template>

<xsl:template match="controller[workspaceRole='NOT_IN_WORKSPACE' and isInContainerViewController='true']" mode="container-impl-import">
#import "MFMultiPanelViewController.h"
</xsl:template>

<xsl:template match="controller" mode="container-impl-import">
</xsl:template>

<!-- attribute -->
<xsl:template match="controller[workspaceRole='WORKSPACE_DETAIL']" mode="container-impl-attirbutes">
@synthesize columnIndex = _columnIndex;
</xsl:template>

<xsl:template match="controller" mode="container-impl-attirbutes">
</xsl:template>

<!-- methods -->
<xsl:template match="controller[isInContainerViewController='true']" mode="container-impl-methods">
	<xsl:apply-templates select="." mode="container-impl-commons-method"/>
	
	<xsl:if test="count(saveActionNames/saveActionName)&gt;0">
		- (NSArray *)saveActionsNames
		{
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">saveActionsNames</xsl:with-param>
				<xsl:with-param name="defaultSource">
		    return @[
		    <xsl:for-each select="saveActionNames/saveActionName">
		    	<xsl:choose>
		    		<xsl:when test="position()=1">MFAction_<xsl:value-of select="current()"/></xsl:when>
		    		<xsl:otherwise>, MFAction_<xsl:value-of select="current()"/></xsl:otherwise>
		    	</xsl:choose>
		    </xsl:for-each>
		    ];
		    	</xsl:with-param>
		    </xsl:call-template>
		}
	</xsl:if>
	
</xsl:template>

<xsl:template match="controller[workspaceRole='WORKSPACE_MASTER' or workspaceRole='WORKSPACE_DETAIL']" mode="container-impl-commons-method">
#pragma mark - MFWorkspaceDetailColumnProtocol methods
-(MFWorkspaceViewController *) containerViewController {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">containerViewController</xsl:with-param>
		<xsl:with-param name="defaultSource">
    if([self.parentViewController isKindOfClass:[MFWorkspaceViewController class]]) {
        return (MFWorkspaceViewController *)self.parentViewController;
    }
    return nil;
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

<xsl:template match="controller[workspaceRole='NOT_IN_WORKSPACE' and isInContainerViewController='true']" mode="container-impl-commons-method">
#pragma mark - MFPanelProtocol methods
-(MFMultiPanelViewController *) containerViewController {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">containerViewController</xsl:with-param>
		<xsl:with-param name="defaultSource">
    if([self.parentViewController isKindOfClass:[MFMultiPanelViewController class]]) {
        return (MFMultiPanelViewController *)self.parentViewController;
    }
    return nil;
    	</xsl:with-param>
    </xsl:call-template>
}
</xsl:template>

<xsl:template match="controller" mode="container-impl-methods">
</xsl:template>

</xsl:stylesheet>