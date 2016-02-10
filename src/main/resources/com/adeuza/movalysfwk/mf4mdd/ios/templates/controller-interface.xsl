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

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>
<xsl:include href="controller/container.xsl"/>
<xsl:include href="controller/search.xsl"/>

<xsl:template match="controller">
<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="." mode="container-interface-import"/>
<xsl:apply-templates select="." mode="declare-protocol-imports"/>


<xsl:if test="@controllerType = 'SEARCHVIEW'">
#import "MFFormSearchViewController.h"
</xsl:if>
<xsl:if test="@controllerType = 'FIXEDLISTVIEW'">
#import "MFFormDetailViewController.h"
</xsl:if>

@interface <xsl:value-of select="name"/><xsl:text> : </xsl:text>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-signature</xsl:with-param>
	<xsl:with-param name="defaultSource"><xsl:apply-templates select="." mode="signature"/></xsl:with-param>
</xsl:call-template>	
	
<xsl:text>&#13;</xsl:text>

#pragma mark - Properties

<xsl:apply-templates select="./sections/section[@isNoTable = 'true']/subViews/subView" mode="noTable-outlets"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>


#pragma mark - Methods

<xsl:apply-templates select="." mode="methods"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>

<xsl:template match="subView[localization = 'DEFAULT' or localization = 'DETAIL']" mode="noTable-outlets">
	<xsl:text>@property (weak, nonatomic) IBOutlet MFLabel</xsl:text>
	<xsl:text> *</xsl:text>
	<xsl:value-of select="propertyName"></xsl:value-of><xsl:text>_label_</xsl:text><xsl:value-of select="../../@name"></xsl:value-of>
	<xsl:text>;&#13;</xsl:text>
	
	<xsl:text>@property (weak, nonatomic) IBOutlet </xsl:text>
	<xsl:choose>
		<xsl:when test="./customClass = 'MFPickerList' or ./customClass = 'MFFixedList'">
			<xsl:text>MFUIBaseComponent</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="customClass"></xsl:value-of>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> *</xsl:text>
	<xsl:value-of select="propertyName"></xsl:value-of><xsl:text>_</xsl:text><xsl:value-of select="../../@name"></xsl:value-of>
	<xsl:text>;&#13;</xsl:text>
</xsl:template>

<xsl:template match="subView[localization = 'LIST']" mode="noTable-outlets">
</xsl:template>

<xsl:template match="controller[@controllerType = 'SEARCHVIEW']" mode="signature">
	<xsl:text>MFFormSearchViewController</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller[@controllerType = 'FORMVIEW']" mode="signature">
	<xsl:text>MFFormViewController</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller[@controllerType = 'LISTVIEW']" mode="signature">
	<xsl:text>MFFormListViewController</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller[@controllerType = 'FIXEDLISTVIEW']" mode="signature">
	<xsl:text>MFFormDetailViewController</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller[@controllerType = 'LISTVIEW2D']" mode="signature">
	<xsl:text>MFForm2DListViewController</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller" mode="signature">
	<xsl:text>NSObject</xsl:text><xsl:apply-templates select="." mode="signature-protocol"/>
</xsl:template>

<xsl:template match="controller" mode="signature-protocol">
	<xsl:choose>
		<xsl:when test="(@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D' or @controllerType='LISTVIEW3D') and workspaceRole='WORKSPACE_MASTER'">
			<xsl:text>&lt;MFFormViewControllerProtocol, MFWorkspaceMasterColumnProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@controllerType='FORMVIEW' and workspaceRole='WORKSPACE_DETAIL' and count(saveActionNames/saveActionName)&gt;0">
			<xsl:text>&lt;MFFormViewControllerProtocol, MFChildSaveProtocol, MFWorkspaceDetailColumnProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@controllerType='FORMVIEW' and workspaceRole='WORKSPACE_DETAIL'">
			<xsl:text>&lt;MFFormViewControllerProtocol, MFWorkspaceDetailColumnProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@controllerType='FORMVIEW' and workspaceRole='NOT_IN_WORKSPACE' and isInContainerViewController='true' and count(saveActionNames/saveActionName)&gt;0">
			<xsl:text>&lt;MFFormViewControllerProtocol, MFChildSaveProtocol, MFPanelProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="workspaceRole='NOT_IN_WORKSPACE' and isInContainerViewController='true'">
			<xsl:text>&lt;MFFormViewControllerProtocol, MFPanelProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@controllerType = 'FORMVIEW'">
			<xsl:text>&lt;MFFormViewControllerProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@controllerType='SEARCHVIEW'">
			<xsl:text>&lt;MFFormViewControllerProtocol&gt;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="controller[@controllerType = 'FORMVIEW' or @controllerType = 'LISTVIEW' or @controllerType = 'SEARCHVIEW']" mode="methods">
/**
 * @brief Invoked when load data action succeed
 * @param context context
 * @param caller caller of action
 * @param result action result
 */
- (void) succeedLoadDataAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result ;

/**
 * @brief Invoked when load data action succeed failed
 * @param context context
 * @param caller caller of action
 * @param result action result
 */
- (void) failLoadDataAction:(id&lt;MFContextProtocol&gt;) context withCaller:(id)caller andResult:(id)result ;
</xsl:template>


<xsl:template match="controller" mode="methods">

</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>
